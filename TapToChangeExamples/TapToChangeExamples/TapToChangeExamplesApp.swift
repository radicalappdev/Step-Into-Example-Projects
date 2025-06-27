//
//  TapToChangeExamplesApp.swift
//  TapToChangeExamples
//
//  Created by Joseph Simpson on 6/27/25.
//

import SwiftUI

@main
struct TapToChangeExamplesApp: App {

    @State private var appModel = AppModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appModel)
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
        .immersionStyle(selection: .constant(.full), in: .full)

    }
}
