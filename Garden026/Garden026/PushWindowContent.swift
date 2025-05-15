//
//  PushWindowContent.swift
//  Garden026
//
//  Created by Joseph Simpson on 5/15/25.
//

import SwiftUI

struct PushWindowContent: View {

    @Environment(AppModel.self) private var appModel
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace

    @Environment(\.dismissWindow) private var dismissWindow

    var body: some View {
        VStack(spacing: 24) {
            Text("Immersive Controls")
                .font(.title)
            Text("An example of a small window for controls in an immersive space.")

            Button(action: {
                Task {
                    if(appModel.gardenOpen) {
                        await dismissImmersiveSpace()
                        dismissWindow()
                        return
                    } else if (!appModel.gardenOpen) {
                        await openImmersiveSpace(id: "GardenScene")
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
                appModel.pushlWindowOpen = false
            case .active:
                appModel.pushlWindowOpen = true
            @unknown default:
                appModel.pushlWindowOpen = false
            }
        }
    }
}

#Preview {
    PushWindowContent()
}
