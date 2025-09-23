//
//  AppModel.swift
//  StepIntoTrackedControllers
//
//  Created by Joseph Simpson on 9/22/25.
//

import SwiftUI
import ARKit
import RealityKit
import GameController

/// Maintains app-wide state
@MainActor
@Observable
class AppModel {

    // Immersive Space state
    let immersiveSpaceID = "ImmersiveSpace"
    enum ImmersiveSpaceState {
        case closed
        case inTransition
        case open
    }
    var immersiveSpaceState = ImmersiveSpaceState.closed


    // ARKit Controller Tracking
    let arkitSession = ARKitSession()
    var trackingState: TrackingState = .startingUp

    var leftControllerConnected = false
    var rightControllerConnected = false

    var leftTransform: Transform?
    var rightTransform: Transform?

    enum TrackingState: String {
        case startingUp = "Starting Up"
        case trackingNotAuthorized = "Tracking Not Authorized"
        case trackingNotSupported = "Tracking Not Supported"
        case noControllerConnected = "No Controller Connected"
        case arkitSessionError = "ARKit Session Error"
        case tracking = "Tracking"
    }

    init() {

        if !AccessoryTrackingProvider.isSupported {
            trackingState = .trackingNotSupported
            return
        }

        NotificationCenter.default.addObserver(forName: NSNotification.Name.GCControllerDidConnect, object: nil, queue: nil) { notification in
                if let controller = notification.object as? GCController {
                    switch controller.productCategory {
                    case GCProductCategorySpatialController:
                        Task { @MainActor in
                            print("A spatial controller connected")
                            self.trackAllConnectedSpatialControllers()
                        }
                    default:
                        print("A standard controller connected")
                    }
                }
            }

        NotificationCenter.default.addObserver(forName: NSNotification.Name.GCControllerDidDisconnect, object: nil, queue: nil) { notification in
            if let controller = notification.object as? GCController {
                switch controller.productCategory {
                case GCProductCategorySpatialController:
                    Task { @MainActor in
                        print("A spatial controller disconnected")
                        // When disconnecting a controller, rerun this to continue tracking remaining controllers
                        self.trackAllConnectedSpatialControllers()
                    }
                default:
                    print("A standard controller disconnected")
                }
            }
        }

        // Start tracking any controllers that were connected before init
        trackAllConnectedSpatialControllers()
    }


    private func trackAllConnectedSpatialControllers() {
        Task {
            guard trackingState != .trackingNotSupported && trackingState != .trackingNotAuthorized else {
                print("Can't run ARKit session: \(trackingState)")
                return
            }

            var accessories: [Accessory] = []
            for spatialController in GCController
                .controllers()
                .filter({ $0.productCategory == GCProductCategorySpatialController }) {
                do {
                    let accessory = try await Accessory(device: spatialController)
                    accessories.append(accessory)
                } catch {
                    print("Error during accessory initialization: \(error)")
                }
            }

            guard !accessories.isEmpty else {
                print("CONTROLLER nothing to process")
                trackingState = .noControllerConnected
                leftControllerConnected = false
                rightControllerConnected = false
                arkitSession.stop()
                return
            }

            let accessoryTracking = AccessoryTrackingProvider(accessories: accessories)

            do {
                try await arkitSession.run([accessoryTracking])
                trackingState = .tracking

            } catch {
                // No need to handle the error here; the app is already monitoring the
                // session for errors in `monitorSessionEvents()`.
                return
            }

            for await update in accessoryTracking.anchorUpdates {
                process(update)
            }
        }
    }


    private func process(_ update: AnchorUpdate<AccessoryAnchor>) {

        switch update.event {
        case .added:

            print("CONTROLLER anchor updates: added")

            if(update.anchor.accessory.inherentChirality == .left) {
                leftControllerConnected = update.anchor.isTracked
            } else {
                rightControllerConnected = update.anchor.isTracked
            }

        case .updated:
            if(update.anchor.accessory.inherentChirality == .left) {
                leftTransform = Transform(matrix: update.anchor.originFromAnchorTransform)

            } else {
                rightTransform = Transform(matrix: update.anchor.originFromAnchorTransform)
            }



        case .removed:

            print("CONTROLLER anchor updates: removed")

            if(update.anchor.accessory.inherentChirality == .left) {
                leftControllerConnected = update.anchor.isTracked
            } else {
                rightControllerConnected = update.anchor.isTracked
            }

            return
        }

    }



}





