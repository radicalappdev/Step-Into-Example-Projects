//
//  Spatial_Interfaces_001App.swift
//  Spatial Interfaces 001
//
//  Created by Joseph Simpson on 5/21/25.
//

import SwiftUI

@main
struct Spatial_Interfaces_001App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(
                    minWidth: 400,
                    idealWidth: 1200,
                    maxWidth: 2000,
                    minHeight: 400,
                    idealHeight: 800,
                    maxHeight: 2000,
                    alignment: .center
                )
        }
        .windowStyle(.plain)
        .windowResizability(.contentSize)
        .defaultSize(width: 1200, height: 600)
    }
}
