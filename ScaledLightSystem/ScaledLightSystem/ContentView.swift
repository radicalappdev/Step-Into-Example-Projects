//
//  ContentView.swift
//  ScaledLightSystem
//
//  Created by Joseph Simpson on 9/9/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    /// A top level entity that will be scaled with the volume. Only the root view will be added to this
    @State private var volumeRootEntity = Entity()

    @State private var useScaledLights = true

    var body: some View {
        GeometryReader3D { proxy in
            RealityView { content in

                content.add(volumeRootEntity)

                /// A root view for the graveyard content.  All other entities will be added to this.
                guard let baseRoot = try? await Entity(named: "Scene", in: realityKitContentBundle) else { return }
                baseRoot.name = "TableScene"
                baseRoot.position = [0, -0.45, 0] // Move this down to the bottom of the volume
                volumeRootEntity.addChild(baseRoot, preservingWorldTransform: true)

                guard let subject = baseRoot.findEntity(named: "BunsenBurner") else { return }
                let mc = ManipulationComponent()
                subject.components.set(mc)

            } update: { content in

                volumeRootEntity.scaleWithVolume(content, proxy)


            }
            .debugBorder3D(.white)

        }
    }
}

#Preview(windowStyle: .volumetric) {
    ContentView()
}

