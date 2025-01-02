//
//  AppModel.swift
//  Garden019
//
//  Created by Joseph Simpson on 1/2/25.
//

import SwiftUI

/// Maintains app-wide state
@MainActor
@Observable
class AppModel {
    var mainWindowOpen: Bool = false
    var loadingWindowOpen: Bool = false

    var immersiceBlueOpen: Bool = false
    var immersiceGreenOpen: Bool = false
    var immersiceRedOpen: Bool = false

    var spaceToOpen: String? = nil

    /// This willl return true if any one of our immersice spaces are open
    var immersiveSpaceActive: Bool {
        return immersiceBlueOpen || immersiceGreenOpen || immersiceRedOpen
    }
}
