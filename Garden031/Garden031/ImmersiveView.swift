//
//  ImmersiveView.swift
//  Garden031
//
//  Created by Joseph Simpson on 8/18/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    @Environment(AppModel.self) private var appModel
    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            if let immersiveContentEntity = try? await Entity(named: "Immersive", in: realityKitContentBundle) {
                content.add(immersiveContentEntity)
            }
        } update: { content in
            guard let skyDome = content.entities.first?.findEntity(named: "SkyDome") else { return }
            guard let pillars = content.entities.first?.findEntity(named: "Pillars") else { return }

            if appModel.immersiveStyle is MixedImmersionStyle {
                skyDome.isEnabled = false
                pillars.isEnabled = false
            } else if appModel.immersiveStyle is FullImmersionStyle {
                skyDome.isEnabled = true
                pillars.isEnabled = true
            } else if appModel.immersiveStyle is ProgressiveImmersionStyle {
                skyDome.isEnabled = true
                pillars.isEnabled = false
            }
        }

    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
        .environment(AppModel())
}
