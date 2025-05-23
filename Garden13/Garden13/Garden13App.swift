//
//  Garden13App.swift
//  Garden13
//
//  Created by Joseph Simpson on 11/21/24.
//

import SwiftUI

@main
struct Garden13App: App {

    @State private var appModel = AppModel()

    var body: some Scene {
        WindowGroup(id: "MainWindow") {
            ContentView()
                .environment(appModel)
        }
        .defaultSize(CGSize(width: 600, height: 600))

        // Give the space an ID and a view
        ImmersiveSpace(id: "GardenScene") {
            ImmersiveView()
                .environment(appModel)
        }
    }
}
