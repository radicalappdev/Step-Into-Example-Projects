//  Step Into Vision - Example Code
//
//  Title: ImmersiveSpace
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 6/25/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveSpaceRoot: View {
    var body: some View {
        RealityView { content in

            let subject = ModelEntity(
                mesh: .generateSphere(radius: 0.25),
                materials: [SimpleMaterial(color: .cyan, isMetallic: false)]
            )
            subject.position = .init(x: 1, y: 1, z: -4)
            content.add(subject)

        }
        .onDisappear() {
            print("EXITING IMMERSIVE SPACE")
        }
    }
}


#Preview("Mixed immersive space", immersionStyle: .mixed) {
    ImmersiveSpaceRoot()
}
