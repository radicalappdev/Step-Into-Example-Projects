//
//  ImmersiveView.swift
//  Issue_OnTapBehavior
//
//  Created by Joseph Simpson on 2/4/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {

    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            if let immersiveContentEntity = try? await Entity(named: "Immersive", in: realityKitContentBundle) {
                content.add(immersiveContentEntity)

                // Put skybox here.  See example in World project available at
                // https://developer.apple.com/
            }
        }
        .gesture(TapGesture().targetedToAnyEntity()
            .onEnded({ value in
                _ = value.entity.applyTapForBehaviors()
            })
        )
    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
        .environment(AppModel())
}
