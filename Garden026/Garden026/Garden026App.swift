//
//  Garden026App.swift
//  Garden026
//
//  Created by Joseph Simpson on 5/15/25.
//

import SwiftUI

@main
struct Garden026App: App {

    @State private var appModel = AppModel()

    var body: some Scene {
        WindowGroup(id: "MainWindow") {
            ContentView()
                .environment(appModel)
        }
        .defaultSize(CGSize(width: 600, height: 600))

        WindowGroup(id: "PushWindow") {
            PushWindowContent()
                .environment(appModel)
        }
        .defaultSize(CGSize(width: 300, height: 300))

        ImmersiveSpace(id: "GardenScene") {
            ImmersiveView()
                .environment(appModel)

        }
        .immersionStyle(selection: .constant(.full), in: .full)
    }
}
