//
//  ImmersiveView.swift
//  Garden025
//
//  Created by Joseph Simpson on 5/14/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    @Environment(AppModel.self) private var appModel
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace

    @State var tapCount = 0

    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            if let root = try? await Entity(named: "Immersive", in: realityKitContentBundle) {
                content.add(root)

                if let glassSphere = root.findEntity(named: "GlassSphere") {
                    createClones(root, glassSphere: glassSphere)
                }
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
                value.entity.removeFromParent()
                tapCount += 1
                if(tapCount >= 5) {
                    Task {
                        await dismissImmersiveSpace()
                    }
                }
            }
    }

    func createClones(_ root: Entity, glassSphere: Entity) {
        let centerPos = SIMD3<Float>(0, 1.5, 0)
        for _ in 1...100 {
            let clone = glassSphere.clone(recursive: true)
            // Random spherical coordinates - thanks ChatGPT!
            let distance = Float.random(in: 1...3) // Radius between 1 and 3
            let theta = Float.random(in: 0...(2 * .pi)) // Random angle for the horizontal plane
            let phi = Float.random(in: 0...(Float.pi)) // Random angle for the vertical plane

            // Convert spherical coordinates to Cartesian
            let x = distance * sin(phi) * cos(theta)
            let y = distance * sin(phi) * sin(theta)
            let z = distance * cos(phi)
            clone.position = centerPos + SIMD3(x, y, z)
            root.addChild(clone)
        }
    }
}
