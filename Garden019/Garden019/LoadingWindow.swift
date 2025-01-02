//
//  LoadingWindow.swift
//  Garden019
//
//  Created by Joseph Simpson on 1/2/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct LoadingWindow: View {

    @Environment(AppModel.self) private var appModel
    @Environment(\.scenePhase) private var scenePhase

    @Environment(\.dismissWindow) private var dismissWindow
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace

    var body: some View {
        VStack {
            RealityView { content in
                if let root = try? await Entity(named: "Loading", in: realityKitContentBundle) {
                    root.scale = [0.1, 0.1, 0.1]
                    content.add(root)
                }
            }

        }
        .persistentSystemOverlays(.hidden)
        .onChange(of: scenePhase, initial: true) {
            switch scenePhase {
            case .inactive, .background:
                appModel.loadingWindowOpen = false
            case .active:
                appModel.loadingWindowOpen = true
            @unknown default:
                appModel.loadingWindowOpen = false
            }
        }
        .onAppear() {
            Task {
                if(appModel.immersiveSpaceActive) {
                    await dismissImmersiveSpace()

                    try? await Task.sleep(nanoseconds: 100_000_000_0)

                    if let space = appModel.spaceToOpen {
                        await openImmersiveSpace(id: space)
                        appModel.spaceToOpen = nil
                        dismissWindow(id: "LoadingWindow")
                    }
                }
            }
        }
    }
}
