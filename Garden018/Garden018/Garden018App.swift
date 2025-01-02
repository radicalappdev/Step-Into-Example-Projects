//
//  Garden018App.swift
//  Garden018
//
//  Created by Joseph Simpson on 1/2/25.
//

import SwiftUI

@main
struct Garden018App: App {

    @State private var appModel = AppModel()

    var body: some Scene {
        WindowGroup(id: "MainWindow") {
            ContentView()
                .environment(appModel)
        }
        .defaultSize(CGSize(width: 600, height: 600))

        ImmersiveSpace(id: "GardenScene") {
            ImmersiveView()
                .environment(appModel)

        }
        .immersionStyle(selection: .constant(.full), in: .full)
    }
}
