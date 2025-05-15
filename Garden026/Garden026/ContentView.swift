//
//  ContentView.swift
//  Garden026
//
//  Created by Joseph Simpson on 5/15/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    @Environment(AppModel.self) private var appModel
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace

    @Environment(\.pushWindow) private var pushWindow

    var body: some View {
        VStack(spacing: 24) {
            Text("🫧")
                .font(.extraLargeTitle2)
            Text("Bubble Garden")
                .font(.title)
            Text("Immersive Spaces")
                .font(.extraLargeTitle)

            Text("We can replace this window with another while in an immersive space.")

            Button(action: {
                Task {
                    if(appModel.gardenOpen) {
                        await dismissImmersiveSpace()
                        return
                    } else if (!appModel.gardenOpen) {
                        await openImmersiveSpace(id: "GardenScene")
                        pushWindow(id: "PushWindow")
                    }
                }
            }, label: {
                Text(appModel.gardenOpen ? "Close Immersive Space" :"Open Immersive Space")
            })
        }
        .padding()
        .onChange(of: scenePhase, initial: true) {
            switch scenePhase {
            case .inactive, .background:
                appModel.mainWindowOpen = false
            case .active:
                appModel.mainWindowOpen = true
            @unknown default:
                appModel.mainWindowOpen = false
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}


