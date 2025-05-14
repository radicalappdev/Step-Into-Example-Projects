//
//  AppModel.swift
//  Garden025
//
//  Created by Joseph Simpson on 5/14/25.
//

import SwiftUI

/// Maintains app-wide state
@MainActor
@Observable
class AppModel {
    var mainWindowOpen: Bool = false
    var gardenOpen: Bool = false
}
