//
//  AppModel.swift
//  Garden022
//
//  Created by Joseph Simpson on 2/27/25.
//

import SwiftUI

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
    
    var windowIsOpen: Bool = false
    var volumeIsOpen: Bool = false
}
