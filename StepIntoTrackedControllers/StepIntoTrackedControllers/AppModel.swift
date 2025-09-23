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
    let immersiveSpaceID = "ImmersiveSpace"
    enum ImmersiveSpaceState {
        case closed
        case inTransition
        case open
    }
    var immersiveSpaceState = ImmersiveSpaceState.closed

    let arkitSession = ARKitSession()
    var trackingState: TrackingState = .startingUp

    var leftControllerConnected = false
    var rightControllerConnected = false

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
                            // A spatial controller connected.
                            print("A spatial controller connected")
                            self.trackAllConnectedSpatialControllers()
                        }
                    default:
                        // A standard controller connected.
                        print("A standard controller connected")
                    }
                }
            }

        NotificationCenter.default.addObserver(forName: NSNotification.Name.GCControllerDidDisconnect, object: nil, queue: nil) { notification in
            if let controller = notification.object as? GCController {
                switch controller.productCategory {
                case GCProductCategorySpatialController:
                    Task { @MainActor in
                        // A spatial controller connected.
                        print("A spatial controller disconnected")
                        self.trackAllConnectedSpatialControllers()
                    }
                default:
                    // A standard controller connected.
                    print("A standard controller disconnected")
                }
            }
        }

        // Start tracking any spatial controllers that are already connected.
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
                trackingState = .noControllerConnected
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
        case .added, .updated:

            if(update.anchor.accessory.inherentChirality == .left) {
                leftControllerConnected = update.anchor.isTracked
            }

            if(update.anchor.accessory.inherentChirality == .right) {
                leftControllerConnected = update.anchor.isTracked
            }

        case .removed:

            if(update.anchor.accessory.inherentChirality == .left) {
                leftControllerConnected = update.anchor.isTracked
            }

            if(update.anchor.accessory.inherentChirality == .right) {
                leftControllerConnected = update.anchor.isTracked
            }

            return
        }
    }



}
