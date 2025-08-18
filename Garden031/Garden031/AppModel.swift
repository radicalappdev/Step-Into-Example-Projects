//
//  AppModel.swift
//  Garden031
//
//  Created by Joseph Simpson on 8/18/25.
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

    var immersiveStyle: ImmersionStyle = .mixed
}
