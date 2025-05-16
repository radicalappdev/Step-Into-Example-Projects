//
//  AppModel.swift
//  Garden027
//
//  Created by Joseph Simpson on 5/16/25.
//

import SwiftUI

/// Maintains app-wide state
@MainActor
@Observable
class AppModel {
    var mainWindowOpen: Bool = false
    var pushWindowOpen: Bool = false
    var gardenOpen: Bool = false
}
