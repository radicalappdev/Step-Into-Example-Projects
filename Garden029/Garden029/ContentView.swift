//
//  ContentView.swift
//  Garden029
//
//  Created by Joseph Simpson on 7/12/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    var body: some View {
        VStack(spacing: 24) {

            Text("Immersive Garden")
                .font(.title)

            Text("Working with `.immersiveEnvironmentBehavior`")

            ToggleImmersiveSpaceButton()
        }
        .padding()
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
