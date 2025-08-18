//
//  Garden031App.swift
//  Garden031
//
//  Created by Joseph Simpson on 8/18/25.
//

import SwiftUI

@main
struct Garden031App: App {

    @State private var appModel = AppModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appModel)
        }
        .defaultSize(width: 400, height: 400, depth: 400)

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
        // the value for immersiveStyle is defined in the App Model so we can easily change it from the ContentView
        .immersionStyle(selection: $appModel.immersiveStyle, in: .mixed, .full, .progressive)
     }
}
