//
//  ContentView.swift
//  Garden-24
//
//  Created by Joseph Simpson on 5/12/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    @State var subject = Entity()

    var body: some View {
        RealityView { content in

            guard let scene = try? await Entity(named: "Scene", in: realityKitContentBundle) else { return }
            content.add(scene)
            scene.position.y = -0.2

            guard let skull = scene.findEntity(named: "Skull") else { return }
            subject = skull

        }
        .onVolumeViewpointChange { _, newValue in

            // Get a rotation value from the squareAzimuth
            let newRotation = simd_quatf(newValue.squareAzimuth.orientation)

            // Set the orientation of content in our scene
            subject.orientation = newRotation

        }

    }
}

#Preview(windowStyle: .volumetric) {
    ContentView()
}



