//
//  VolumeContent.swift
//  Garden022
//
//  Created by Joseph Simpson on 2/27/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct VolumeContent: View {

    @Environment(AppModel.self) private var appModel
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        RealityView { content in
            if let immersiveContentEntity = try? await Entity(named: "Immersive", in: realityKitContentBundle) {
                content.add(immersiveContentEntity)
                immersiveContentEntity.scale = [0.5, 0.5, 0.5]
            }
        }
        .onChange(of: scenePhase, initial: true) {
            switch scenePhase {
            case .inactive, .background:
                appModel.volumeIsOpen = false
            case .active:
                appModel.volumeIsOpen = true
            @unknown default:
                appModel.volumeIsOpen = false
            }
        }
    }
}

#Preview {
    VolumeContent()
}
