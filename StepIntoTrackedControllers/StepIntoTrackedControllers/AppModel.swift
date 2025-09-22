//
//  AppModel.swift
//  StepIntoTrackedControllers
//
//  Created by Joseph Simpson on 9/22/25.
//

import SwiftUI
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



    init() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.GCControllerDidConnect, object: nil, queue: nil) { notification in
                if let controller = notification.object as? GCController {
                    switch controller.productCategory {
                    case GCProductCategorySpatialController:
                        // A spatial controller connected.
                        print("A spatial controller connected")
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
                    // A spatial controller connected.
                    print("A spatial controller disconnected")
                default:
                    // A standard controller connected.
                    print("A standard controller disconnected")
                }
            }
        }
    }



}
