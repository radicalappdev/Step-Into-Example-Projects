//
//  ContentView.swift
//  Garden031
//
//  Created by Joseph Simpson on 8/18/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    @Environment(AppModel.self) private var appModel

    var body: some View {
        VStack {
            Model3D(named: "Scene", bundle: realityKitContentBundle)
                .padding(.bottom, 50)

            Text("Hello, world!")

            ToggleImmersiveSpaceButton()

            Button(action: {
                appModel.immersiveStyle = .full
            }, label: {
                Text("Full")
            })
        }
        .padding()
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
