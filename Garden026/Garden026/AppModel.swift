//
//  AppModel.swift
//  Garden026
//
//  Created by Joseph Simpson on 5/15/25.
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
