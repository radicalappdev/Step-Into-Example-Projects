//
//  ImmersiveView.swift
//  Garden019
//
//  Created by Joseph Simpson on 1/2/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    @Environment(AppModel.self) private var appModel
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace

    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            if let root = try? await Entity(named: "BlueDome", in: realityKitContentBundle) {
                content.add(root)

            }
        }
        .gesture(tap)
        .onChange(of: scenePhase, initial: true) {
            switch scenePhase {
            case .inactive, .background:
                appModel.gardenOpen = false
            case .active:
                appModel.gardenOpen = true
            @unknown default:
                appModel.gardenOpen = false
            }
        }
    }

    var tap: some Gesture {
        TapGesture()
            .targetedToAnyEntity()
            .onEnded { value in
                // TODO: check the entity for navigation destination
            }
    }

//    func openMainWindow() {
//
//        Task {
//            openWindow(id: "MainWindow")
//
//            // Start checking if window is open.
//            while !appModel.mainWindowOpen {
//                try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
//            }
//            // Once the main window has opened, dismiss immersive space
//            await dismissImmersiveSpace()
//
//        }
//
//    }

}


#Preview(immersionStyle: .full) {
    ImmersiveView()
        .environment(AppModel())
}
