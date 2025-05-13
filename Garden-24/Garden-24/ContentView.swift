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

    let supportedViewpoints = SquareAzimuth.Set(arrayLiteral: .front, .left, .right)

    var body: some View {
        RealityView { content in

            guard let scene = try? await Entity(named: "Scene", in: realityKitContentBundle) else { return }
            content.add(scene)
            scene.position.y = -0.2

            guard let skull = scene.findEntity(named: "Skull") else { return }
            subject = skull

        }

        .onVolumeViewpointChange(updateStrategy: .supported) { _, newValue in

            if (supportedViewpoints.contains(newValue.squareAzimuth)) {
                // Get a rotation value from the squareAzimuth
                let newRotation = simd_quatf(newValue.squareAzimuth.orientation)

                // Set the orientation of content in our scene
                subject.orientation = newRotation
                print("viewpoint supported")

            } else {
                print("viewpoint not supported")
            }

        }
        .supportedVolumeViewpoints(supportedViewpoints)

    }
}

#Preview(windowStyle: .volumetric) {
    ContentView()
}


