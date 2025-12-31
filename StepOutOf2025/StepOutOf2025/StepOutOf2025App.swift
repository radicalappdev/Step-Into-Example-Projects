//
//  StepOutOf2025App.swift
//  StepOutOf2025
//
//  Created by Joseph Simpson on 12/31/25.
//

import SwiftUI

@main
struct StepOutOf2025App: App {

    @State private var appModel = AppModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appModel)

        }
//        .defaultSize(width: 600, height: 600)
        .defaultSize(width: 1800, height: 1400)

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
        .immersionStyle(selection: .constant(.full), in: .full)
    }
}
