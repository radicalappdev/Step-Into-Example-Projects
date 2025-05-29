//
//  ContentView.swift
//  Pride2025
//
//  Created by Joseph Simpson on 5/29/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    var body: some View {

        ZStack {
            BiGradient()
                .cornerRadius(32)

            VStack {
                Text("Happy Pride")
                    .font(.extraLargeTitle2)
                ToggleImmersiveSpaceButton()
            }
            .padding()
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
