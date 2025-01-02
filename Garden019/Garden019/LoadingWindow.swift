//
//  LoadingWindow.swift
//  Garden019
//
//  Created by Joseph Simpson on 1/2/25.
//

import SwiftUI

struct LoadingWindow: View {

    @Environment(AppModel.self) private var appModel
    @Environment(\.scenePhase) private var scenePhase

    @Environment(\.dismissWindow) private var dismissWindow
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace

    var body: some View {
        VStack {
            Text("Loading")

        }
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
