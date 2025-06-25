//
//  ContentView.swift
//  Garden028
//
//  Created by Joseph Simpson on 6/24/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    @Environment(\.openWindow) var openWindow
    @Environment(\.openImmersiveSpace) var openImmersiveSpace

    var body: some View {
        VStack(spacing: 24) {
            Text("Window Garden 🌸")
                .font(.extraLargeTitle2)

            Button(action: {
                openWindow(id: "UtilityWindow")

            }, label: {
                Label("Open Window", systemImage: "inset.filled.center.rectangle.badge.plus")
            })

            Button(action: {
                Task {
                    await openImmersiveSpace(id: "ImmersiveSpace")
                }

            }, label: {
                Label("Open Space", systemImage: "inset.filled.center.rectangle.badge.plus")
            })
        }
        .padding()
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
