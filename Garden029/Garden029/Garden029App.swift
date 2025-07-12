//
//  Garden029App.swift
//  Garden029
//
//  Created by Joseph Simpson on 7/12/25.
//

import SwiftUI

@main
struct Garden029App: App {

    @State private var appModel = AppModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appModel)
        }
        .defaultSize(width: 400, height: 300)

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
        .immersiveEnvironmentBehavior(.coexist)
     }
}
