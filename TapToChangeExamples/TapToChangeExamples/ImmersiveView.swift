//
//  ImmersiveView.swift
//  TapToChangeExamples
//
//  Created by Joseph Simpson on 6/27/25.
//  Learn more: https://stepinto.vision/learn-visionos/
//
//  Gesture basics: https://stepinto.vision/learn-visionos/#system-gestures

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {

    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace

    var body: some View {
        RealityView { content in

            let commonRoot = Entity()
            content.add(commonRoot)


            // Add the initial RealityKit content
            guard let scene1 = try? await Entity(named: "Immersive", in: realityKitContentBundle) else { return}
            commonRoot.addChild(scene1)

            // We'll also go ahead and grab the second scene
            // If your scenes are large, you may want to wait until you need them to load them
            guard let scene2 = try? await Entity(named: "ImmersiveScene2", in: realityKitContentBundle) else { return}


            // Question 1: When an object is tapped, change the scene
            // Do you mean go to another scene?
            // load a second Reality Composer Pro scene when we tap this sphere
            // Alternative: leave the current immersive space and enter another one.
            // See: https://stepinto.vision/example-code/how-to-transition-from-one-immersive-space-to-another-part-two/
            if let sphere1 = scene1.findEntity(named: "Sphere1") {

                // Create a gesture
                let tapGesture = TapGesture()
                    .onEnded({
                        commonRoot.addChild(scene2)
                        scene1.removeFromParent()
                    })

                // Pass the gestutre to GestureComponent
                let gestureComponent = GestureComponent(tapGesture)

                // Add GestureComponent to the entity
                sphere1.components.set(gestureComponent)

            }

            // Example of changing something in a scene when tapping on sphere 3
            if let sphere3 = scene1.findEntity(named: "Sphere3") {
                let tapGesture = TapGesture()
                    .onEnded({
                        // Do something to change the scene
                        sphere3.position.y += 0.2
                    })

                let gestureComponent = GestureComponent(tapGesture)
                sphere3.components.set(gestureComponent)
            }


            // Question 2: When an object is tapped, change the texture/material
            // Replace the existing material with another one
            // Alternative: if you want to change a value for an existing material, see this article
            // https://stepinto.vision/example-code/realitykit-basics-modify-material-values/
            // Textures are a bit tricky to swap out and how you do so will depend on the material type
            if let sphere2 = scene1.findEntity(named: "Sphere2") {
                let tapGesture = TapGesture()
                    .onEnded({
                        let newMaterial = SimpleMaterial(color: .systemRed, isMetallic: false)

                        sphere2.components[ModelComponent.self]?.materials[0] = newMaterial
                    })

                let gestureComponent = GestureComponent(tapGesture)
                sphere2.components.set(gestureComponent)
            }



            // Question 3: When an object is tapped, open a VR Background
            // I assume you mean enter an immersive space? This is normally done with a button or content in a window.
            // See the content view of this example app



            // Question 4: When an object is tapped, close the VR Background
            // Example of exiting the space when tapping on sphere 4
            if let sphere4 = scene1.findEntity(named: "Sphere4") {
                let tapGesture = TapGesture()
                    .onEnded({
                        Task {
                            await dismissImmersiveSpace()
                        }
                    })

                let gestureComponent = GestureComponent(tapGesture)
                sphere4.components.set(gestureComponent)
            }


        }
    }
}

#Preview(immersionStyle: .full) {
    ImmersiveView()
        .environment(AppModel())
}
