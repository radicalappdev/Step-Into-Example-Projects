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
        }

        ImmersiveSpace(id: "GardenScene") {
            ImmersiveView()
                .environment(appModel)

        }
        .immersionStyle(selection: .constant(.full), in: .full)    }
}
