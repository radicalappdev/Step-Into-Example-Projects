//
//  ResourceLibrarySnapshopApp.swift
//  ResourceLibrarySnapshop
//
//  Created by Joseph Simpson on 8/7/25.
//

import SwiftUI

@main
struct ResourceLibrarySnapshopApp: App {

    @State private var appModel = AppModel()

    var body: some Scene {
        WindowGroup(id: "MainWindow") {
            ContentView()
                .environment(appModel)
        }
//        .defaultSize(width: 800, height: 600)
        .windowStyle(.plain)

        ImmersiveSpace(id: appModel.immersiveSpaceID) {
            ImmersiveView()
                .environment(appModel)
                .onAppear {
                    appModel.immersiveSpaceState = .open
                }
                .onDisappear {
                    appModel.immersiveSpaceState = .closed
                }
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
    }
}
