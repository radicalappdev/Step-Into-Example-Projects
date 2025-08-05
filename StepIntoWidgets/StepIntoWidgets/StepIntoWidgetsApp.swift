//
//  StepIntoWidgetsApp.swift
//  StepIntoWidgets
//
//  Created by Joseph Simpson on 7/27/25.
//

import SwiftUI

@main
struct StepIntoWidgetsApp: App {

    @State private var appModel = AppModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appModel)
        }
        .defaultSize(width: 400, height: 400)

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
        .defaultLaunchBehavior(.suppressed)
        .restorationBehavior(.disabled)
     }
}
