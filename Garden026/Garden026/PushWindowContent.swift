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
                appModel.pushWindowOpen = false
                // This is a bit of a hack and may result in exiting the immersive space if the push window is idle for too long
                Task {
                    if(appModel.gardenOpen) {
                        await dismissImmersiveSpace()
                    }
                }
            case .active:
                appModel.pushWindowOpen = true
            @unknown default:
                appModel.pushWindowOpen = false
            }
        }
    }
}

#Preview {
    PushWindowContent()
}
