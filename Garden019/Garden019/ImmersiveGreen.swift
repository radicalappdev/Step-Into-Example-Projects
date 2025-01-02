//
//  ImmersiveGreen.swift
//  Garden019
//
//  Created by Joseph Simpson on 1/2/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveGreen: View {
    @Environment(AppModel.self) private var appModel
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace

    var body: some View {
        RealityView { content in
            if let root = try? await Entity(named: "GreenDome", in: realityKitContentBundle) {
                content.add(root)

            }
        }
        .gesture(tap)
        .onChange(of: scenePhase, initial: true) {
            switch scenePhase {
            case .inactive, .background:
                appModel.immersiceGreenOpen = false
            case .active:
                appModel.immersiceGreenOpen = true
            @unknown default:
                appModel.immersiceGreenOpen = false
            }
        }
    }

    var tap: some Gesture {
        TapGesture()
            .targetedToAnyEntity()
            .onEnded { value in
                if(value.entity.name == "SphereBlue") {
                    appModel.spaceToOpen = "ImmersiveBlue"
                    openWindow(id: "LoadingWindow")
                } else if (value.entity.name == "SphereGreen") {
                    openMainWindow()
                } else if (value.entity.name == "SphereRed") {
                    appModel.spaceToOpen = "ImmersiveRed"
                    openWindow(id: "LoadingWindow")
                }
            }
    }

    func openMainWindow() {
        Task {
            openWindow(id: "MainWindow")
            while !appModel.mainWindowOpen {
                try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
            }
            await dismissImmersiveSpace()
        }
    }

}
