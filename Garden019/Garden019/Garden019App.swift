//
//  Garden019App.swift
//  Garden019
//
//  Created by Joseph Simpson on 1/2/25.
//

import SwiftUI

@main
struct Garden019App: App {

    @State private var appModel = AppModel()

    var body: some Scene {
        WindowGroup(id: "MainWindow") {
            ContentView()
                .environment(appModel)
        }
        .defaultSize(CGSize(width: 600, height: 600))

        WindowGroup(id: "LoadingWindow") {
            LoadingWindow()
                .environment(appModel)
        }
        .windowStyle(.plain)
        .defaultSize(CGSize(width: 400, height: 200))

        ImmersiveSpace(id: "ImmersiveBlue") {
            ImmersiveBlue()
                .environment(appModel)

        }
        .immersionStyle(selection: .constant(.full), in: .full)

        ImmersiveSpace(id: "ImmersiveGreen") {
            ImmersiveGreen()
                .environment(appModel)

        }
        .immersionStyle(selection: .constant(.full), in: .full)


        ImmersiveSpace(id: "ImmersiveRed") {
            ImmersiveRed()
                .environment(appModel)

        }
        .immersionStyle(selection: .constant(.full), in: .full)


    }
}
