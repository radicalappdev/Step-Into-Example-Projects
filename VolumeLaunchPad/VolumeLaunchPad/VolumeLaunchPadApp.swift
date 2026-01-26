//
//  VolumeLaunchPadApp.swift
//  VolumeLaunchPad
//
//  Created by Joseph Simpson on 1/26/26.
//

import SwiftUI

@main
struct VolumeLaunchPadApp: App {

    @State private var appModel = AppModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appModel)
        }
        .windowStyle(.volumetric)
        .defaultSize(width: 0.4, height: 0.4, depth: 0.4, in: .meters) // set initial size in meters
        .volumeWorldAlignment(.gravityAligned) //  keep the volume anchored to the ground

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
