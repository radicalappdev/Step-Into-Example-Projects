//
//  ContentView.swift
//  Garden021
//
//  Created by Joseph Simpson on 2/18/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    @State private var enlarge = false

    var body: some View {
        RealityView { content in

            let rootEntity = Entity()
            content.add(rootEntity)


            var groundMat = PhysicallyBasedMaterial()
            groundMat.baseColor.tint = .init(.stepGreen)
            groundMat.roughness = 0.5
            groundMat.metallic = 0.0

            let groundModel = ModelEntity(
                mesh: .generateBox(size: 1, cornerRadius: 0.1),
                materials: [groundMat])
            groundModel.scale = .init(x: 0.8, y: 0.025, z: 0.8)
            groundModel.position = .init(x: 0, y: -0.44, z: 0)
            rootEntity.addChild(groundModel)

            var blockMat = PhysicallyBasedMaterial()
            blockMat.baseColor.tint = .init(.stepRed)
            blockMat.roughness = 0.5
            blockMat.metallic = 0.0

            let blockModel = ModelEntity(
                mesh: .generateBox(size: 0.5, cornerRadius: 0.05),
                materials: [blockMat])
            blockModel.position = .init(x: 0, y: 0, z: 0)
            rootEntity.addChild(blockModel)


        }


    }
}

#Preview(windowStyle: .volumetric) {
    ContentView()
        .environment(AppModel())
}
