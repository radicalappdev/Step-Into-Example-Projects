//
//  ContentView.swift
//  Garden019
//
//  Created by Joseph Simpson on 1/2/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @Environment(AppModel.self) private var appModel
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissWindow) private var dismissWindow

    var body: some View {
        VStack(spacing: 24) {
            Text("Window Garden")
                .font(.title)
            Text("Immersive Spaces")
                .font(.extraLargeTitle)

            Button(action: {
                Task {
                    if(appModel.immersiceBlueOpen) {
                        await dismissImmersiveSpace()
                        return
                    } else if (!appModel.immersiceBlueOpen) {
                        await openImmersiveSpace(id: "ImmersiveBlue")
                        dismissWindow(id: "MainWindow")
                    }
                }
            }, label: {
                Text(appModel.immersiceBlueOpen ? "Close Immersive Space" :"Open Immersive Space")
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
