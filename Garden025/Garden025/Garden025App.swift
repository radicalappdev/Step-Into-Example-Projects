//
//  Garden025App.swift
//  Garden025
//
//  Created by Joseph Simpson on 5/14/25.
//

import SwiftUI

@main
struct Garden025App: App {

    @State private var appModel = AppModel()

    var body: some Scene {
        WindowGroup(id: "MainWindow") {
            ContentView()
                .environment(appModel)
            // Setup 2: Manually create a resizable window with a glass background
                .frame(
                    minWidth: 300,
                    idealWidth: 600,
                    maxWidth: 1200,
                    minHeight: 300,
                    idealHeight: 600,
                    maxHeight: 800
                )
                .glassBackgroundEffect()
            // Focus: When the immersive space is showing, hide the content.
                .opacity(appModel.gardenOpen ? 0 : 1)
            // Focus: We can also hide the window drag bar and controls
                .persistentSystemOverlays(appModel.gardenOpen ? .hidden : .visible)
        }
        // Setup 1: The window must use .plane style to hide the glass background when we hide the other window content
        .windowResizability(.contentSize)
        .defaultSize(CGSize(width: 600, height: 600))
        .windowStyle(.plain)

        ImmersiveSpace(id: "GardenScene") {
            ImmersiveView()
                .environment(appModel)

        }
        .immersionStyle(selection: .constant(.full), in: .full)    }
}
