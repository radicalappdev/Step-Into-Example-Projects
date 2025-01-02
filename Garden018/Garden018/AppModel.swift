//
//  AppModel.swift
//  Garden018
//
//  Created by Joseph Simpson on 1/2/25.
//

import SwiftUI

/// Maintains app-wide state
@MainActor
@Observable
class AppModel {
    var mainWindowOpen: Bool = false
    var gardenOpen: Bool = false
}
