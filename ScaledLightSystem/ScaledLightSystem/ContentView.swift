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

    init() {
        ScalableLightComponent.registerComponent()
        ScalableLightSystem.registerSystem()
    }

    /// A top level entity that will be scaled with the volume. Only the root view will be added to this
    @State private var volumeRootEntity = Entity()

    @State private var useScaledLights = true

    var body: some View {
        GeometryReader3D { proxy in
            RealityView { content in
                // We'll scale the light based on this entity
                volumeRootEntity.name = "VolumeRoot"
                content.add(volumeRootEntity)

                // Load some content from Reality Composer Pro
                guard let baseRoot = try? await Entity(named: "Scene", in: realityKitContentBundle) else { return }
                baseRoot.name = "TableScene"
                baseRoot.position = [0, -0.45, 0] // Move this down to the bottom of the volume
                volumeRootEntity.addChild(baseRoot, preservingWorldTransform: true)

                // Add manipulation to the Bunsen Burner
                guard let subject = baseRoot.findEntity(named: "BunsenBurner") else { return }
                let mc = ManipulationComponent()
                subject.components.set(mc)

                // Configure the light source with a ScalableLightComponent
                // Add this to any entity with a PointLight or SpotLight
                // The settings entered here will overwrite any values on the PointLight or SpotLight
                guard let lightSource = subject.findEntity(named: "PointLight") else { return }
                let slc = ScalableLightComponent(
                    baseIntensity: 1200,
                    baseRadius: 10,
                    scaleSourceName: "VolumeRoot", // the name of a top-level entity that will be scaled with the volume.
                    referenceScale: 1.0,
                    epsilon: 0.02,
                    nonUniformMode: .average
                )
                lightSource.components.set(slc)

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

