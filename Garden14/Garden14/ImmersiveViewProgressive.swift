//
//  ImmersiveViewProgressive.swift
//  Garden14
//
//  Created by Joseph Simpson on 11/22/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveViewProgressive: View {

    @Environment(AppModel.self) private var appModel
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        ImmersiveSceneContent()
        .onChange(of: scenePhase, initial: true) {
            switch scenePhase {
            case .inactive, .background:
                appModel.gardenProgressiveOpen = false
            case .active:
                appModel.gardenProgressiveOpen = true
            @unknown default:
                appModel.gardenProgressiveOpen = false
            }
        }
    }
}


struct ImmersiveViewProgressiveAlt: View {

    @Environment(AppModel.self) private var appModel
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        ImmersiveSceneContent()
            .onChange(of: scenePhase, initial: true) {
                switch scenePhase {
                case .inactive, .background:
                    appModel.gardenProgressiveAltOpen = false
                case .active:
                    appModel.gardenProgressiveAltOpen = true
                @unknown default:
                    appModel.gardenProgressiveAltOpen = false
                }
            }
    }
}
