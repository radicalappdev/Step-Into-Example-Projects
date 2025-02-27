//
//  Garden022App.swift
//  Garden022
//
//  Created by Joseph Simpson on 2/27/25.
//

import SwiftUI

@main
struct Garden022App: App {

    @State private var appModel = AppModel()

    var body: some Scene {
        WindowGroup(id: "MainWindow") {
            ContentView()
                .environment(appModel)
        }
        .defaultSize(width: 400, height: 400)

        WindowGroup(id: "WindowExample") {
            WindowContent()
                .environment(appModel)
        }
        .defaultSize(width: 500, height: 500)
        .defaultWindowPlacement { content, context in
            if let new = context.windows.first(where: { $0.id == "MainWindow" }) {
                return WindowPlacement(.leading(new))
            } else {
                return WindowPlacement(.none)
            }
        }

        WindowGroup(id: "VolumeExample") {
            VolumeContent()
                .environment(appModel)
        }
        .windowStyle(.volumetric)
        .defaultWindowPlacement { content, context in
            if let new = context.windows.first(where: { $0.id == "MainWindow" }) {
                return WindowPlacement(.trailing(new))
            } else {
                return WindowPlacement(.none)
            }
        }

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
