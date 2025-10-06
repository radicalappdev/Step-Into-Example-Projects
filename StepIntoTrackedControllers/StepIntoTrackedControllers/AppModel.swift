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
    
    var leftController: GCController?
    var rightController: GCController?
    
    var leftControllerConnected: Bool { leftController != nil }
    var rightControllerConnected: Bool { rightController != nil }
    
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
                        self.setupControllerInputs(controller: controller)
                        
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
                        
                        // Clear strong references when the specific controller disconnects
                        if self.leftController === controller {
                            self.leftController = nil
                        }
                        if self.rightController === controller {
                            self.rightController = nil
                        }
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
                    // Maintain strong references to spatial controllers based on chirality
                    switch accessory.inherentChirality {
                    case .left:
                        self.leftController = spatialController
                        self.setupControllerInputs(controller: spatialController, chirality: .left)
                    case .right:
                        self.rightController = spatialController
                        self.setupControllerInputs(controller: spatialController, chirality: .right)
                    default:
                        break
                    }
                    accessories.append(accessory)
                } catch {
                    print("Error during accessory initialization: \(error)")
                }
            }
            
            guard !accessories.isEmpty else {
                print("CONTROLLER nothing to process")
                trackingState = .noControllerConnected
                self.leftController = nil
                self.rightController = nil
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
        case .updated:
            if(update.anchor.accessory.inherentChirality == .left) {
                leftTransform = Transform(matrix: update.anchor.originFromAnchorTransform)
                
            } else {
                rightTransform = Transform(matrix: update.anchor.originFromAnchorTransform)
            }
            
        case .removed:
            print("CONTROLLER anchor updates: removed")
        }
        
    }
    
    func setupControllerInputs(controller: GCController, chirality: Accessory.Chirality? = nil) {
        // Route callbacks to the main actor so state mutations remain safe.
        controller.handlerQueue = .main
        
        let sideLabel: String
        switch chirality {
        case .left: sideLabel = "L"
        case .right: sideLabel = "R"
        default: sideLabel = ""
        }
        print("[\(sideLabel)] setting up inputs")
        
        let profile = controller.physicalInputProfile
        profile.valueDidChangeHandler = { [weak self] _, element in
            guard let self else { return }
            self.handleElementChange(element, sideLabel: sideLabel)
        }
        
        configureTouchpads(in: profile, sideLabel: sideLabel)
    }
    
    private func handleElementChange(_ element: GCControllerElement, sideLabel: String) {
        let elementName = element.localizedName ?? element.aliases.first ?? String(describing: type(of: element))
        
        if let button = element as? GCControllerButtonInput {
            let pressed = button.isPressed
            let value = String(format: "%.2f", button.value)
            print("[\(sideLabel)] \(elementName) pressed: \(pressed) value: \(value)")
            return
        }
        
        if let axis = element as? GCControllerAxisInput {
            let value = String(format: "%.2f", axis.value)
            print("[\(sideLabel)] \(elementName) axis value: \(value)")
            return
        }
        
        if let dpad = element as? GCControllerDirectionPad {
            let x = String(format: "%.2f", dpad.xAxis.value)
            let y = String(format: "%.2f", dpad.yAxis.value)
            print("[\(sideLabel)] \(elementName) dpad x: \(x) y: \(y)")
            return
        }
        
        print("[\(sideLabel)] \(elementName) changed")
    }
    
    private func configureTouchpads(in profile: GCPhysicalInputProfile, sideLabel: String) {
        let touchpads = profile.allTouchpads.compactMap { $0 as? GCControllerTouchpad }
        for touchpad in touchpads {
            let name = touchpad.localizedName ?? touchpad.aliases.first ?? "Touchpad"
            touchpad.touchDown = { _, x, y, buttonValue, buttonPressed in
                let xStr = String(format: "%.2f", x)
                let yStr = String(format: "%.2f", y)
                let buttonValueStr = String(format: "%.2f", buttonValue)
                print("[\(sideLabel)] \(name) touchDown x: \(xStr) y: \(yStr) button: \(buttonValueStr) pressed: \(buttonPressed)")
            }
            touchpad.touchMoved = { _, x, y, buttonValue, buttonPressed in
                let xStr = String(format: "%.2f", x)
                let yStr = String(format: "%.2f", y)
                let buttonValueStr = String(format: "%.2f", buttonValue)
                print("[\(sideLabel)] \(name) touchMoved x: \(xStr) y: \(yStr) button: \(buttonValueStr) pressed: \(buttonPressed)")
            }
            touchpad.touchUp = { _, x, y, buttonValue, buttonPressed in
                let xStr = String(format: "%.2f", x)
                let yStr = String(format: "%.2f", y)
                let buttonValueStr = String(format: "%.2f", buttonValue)
                print("[\(sideLabel)] \(name) touchUp x: \(xStr) y: \(yStr) button: \(buttonValueStr) pressed: \(buttonPressed)")
            }
        }
    }
    
    
    
}
