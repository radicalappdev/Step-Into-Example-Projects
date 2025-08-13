//
//  Garden030App.swift
//  Garden030
//
//  Created by Joseph Simpson on 8/13/25.
//

import SwiftUI

@main
struct Garden030App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .defaultSize(width: 1, height: 1, depth: 1, in: .meters)
        .windowStyle(.volumetric)
    }
}
