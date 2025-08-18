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
        VStack(spacing: 24) {

            Text("Immersive Garden 031")
                .font(.largeTitle)
            Text("Changing immersive style")

            ToggleImmersiveSpaceButton()

            VStack {
                Text("Immerive Style:")
                HStack {
                    Button(action: {
                        appModel.immersiveStyle = .mixed
                    }, label: {
                        Text("Mixed")
                    })
                    Button(action: {
                        appModel.immersiveStyle = .progressive(0.0...1.0, initialAmount: 0.3)
                    }, label: {
                        Text("Progressive")
                    })
                    Button(action: {
                        appModel.immersiveStyle = .full
                    }, label: {
                        Text("Full")
                    })
                }
            }
            .padding(.vertical)

        }
        .padding()
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}

