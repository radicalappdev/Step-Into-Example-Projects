//
//  ContentView.swift
//  Issue_ManipulationTranslation
//
//  Created by Joseph Simpson on 10/7/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {


    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            if let scene = try? await Entity(named: "Scene", in: realityKitContentBundle) {
                content.add(scene)

                if let sphere = scene.findEntity(named: "Sphere") {
                    // Assign ManipulationComponent
                    sphere.components.set(ManipulationComponent())
                }

            }
        }
    }
}

#Preview(windowStyle: .volumetric) {
    ContentView()
}
