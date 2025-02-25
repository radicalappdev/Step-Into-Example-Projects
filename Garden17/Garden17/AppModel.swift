//
//  AppModel.swift
//  Garden17
//
//  Created by Joseph Simpson on 12/4/24.
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

    var progressiveGarden: ImmersionStyle = .progressive(
        0.05...1.0,
        initialAmount: 0.3
    )
    
}
