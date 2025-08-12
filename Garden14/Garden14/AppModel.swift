//
//  AppModel.swift
//  Garden14
//
//  Created by Joseph Simpson on 11/22/24.
//

import SwiftUI

/// Maintains app-wide state
@MainActor
@Observable
class AppModel {
    var mainWindowOpen: Bool = false
    var gardenMixedOpen: Bool = false
    var gardenProgressiveOpen: Bool = false
    var gardenProgressiveAltOpen: Bool = false
    var gardenFullOpen: Bool = false

    var progressiveGarden: ImmersionStyle = .progressive(
        0.2...0.8,
        initialAmount: 0.4,
        aspectRatio: .landscape // or leave nil for default
    )

    var progressiveGardenAlt: ImmersionStyle = .progressive(
        0.2...0.8,
        initialAmount: 0.3,
        aspectRatio: .portrait
    )

    /// This willl return true if any one of our immersice spaces are open
    var immersiveSpaceActive: Bool {
        return gardenMixedOpen || gardenProgressiveOpen  || gardenProgressiveAltOpen || gardenFullOpen
    }

    ///
    var upperLimpVis: Visibility = .automatic
}

