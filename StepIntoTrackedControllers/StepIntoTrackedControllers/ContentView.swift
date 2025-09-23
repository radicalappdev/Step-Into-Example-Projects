//
//  ContentView.swift
//  StepIntoTrackedControllers
//
//  Created by Joseph Simpson on 9/22/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    @Environment(AppModel.self) private var appModel

    var body: some View {
        VStack(spacing: 24) {


            Text("ARKit Tracked Controllers")
                .font(.largeTitle)
            
            Text("Tracking State: \(appModel.trackingState.rawValue)")

            ToggleImmersiveSpaceButton()
        }
        .padding()
        .ornament(visibility: appModel.leftControllerConnected ? .visible : .hidden, attachmentAnchor: .scene(.leading), contentAlignment: .trailing, ornament: {
            VStack {
                Text("Left Controller")
                    .padding()
                    .background(appModel.leftControllerConnected ? Color.green : Color.red)
                    .clipShape(.capsule)
                if let leftTransform = appModel.leftTransform {
                    VectorDisplay(title: "Position", vector: leftTransform.translation)
                    VStack(alignment: .leading) {
                        Text("Rotation \(leftTransform.rotation.angle)")
                            .fontWeight(.bold)
                        VectorDisplay(title: "", vector: leftTransform.rotation.axis)
                    }
                    VectorDisplay(title: "Scale", vector: leftTransform.scale)
                }
            }
            .padding()
            .glassBackgroundEffect()
        })

        .ornament(visibility: appModel.rightControllerConnected ? .visible : .hidden, attachmentAnchor: .scene(.trailing), contentAlignment: .leading, ornament: {
            VStack {
                Text("Right Controller")
                    .padding()
                    .background(appModel.rightControllerConnected ? Color.green : Color.red)
                    .clipShape(.capsule)
                if let rightTransform = appModel.rightTransform {
                    VectorDisplay(title: "Position", vector: rightTransform.translation)
                    VStack(alignment: .leading) {
                        Text("Rotation \(rightTransform.rotation.angle)")
                            .fontWeight(.bold)
                        VectorDisplay(title: "", vector: rightTransform.rotation.axis)
                    }
                    VectorDisplay(title: "Scale", vector: rightTransform.scale)
                }
            }
            .padding()
            .glassBackgroundEffect()
        })

    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}


fileprivate struct VectorDisplay: View {
    let title: String
    let vector: SIMD3<Float>

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .fontWeight(.bold)
            HStack {
                ForEach(["X", "Y", "Z"], id: \.self) { axis in
                    Text("\(axis): \(String(format: "%8.3f", axis == "X" ? vector.x : axis == "Y" ? vector.y : vector.z))")
                        .frame(width: 120, alignment: .leading)
                }
            }
        }
    }
}
