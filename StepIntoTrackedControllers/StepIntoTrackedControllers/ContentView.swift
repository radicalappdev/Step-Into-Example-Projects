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

            HStack {
                Text("Left Controller")
                    .padding()
                    .background(appModel.leftControllerConnected ? Color.green : Color.red)
                    .clipShape(.capsule)
                Text("Right Controller")
                    .padding()
                    .background(appModel.leftControllerConnected ? Color.green : Color.red)
                    .clipShape(.capsule)
            }

            ToggleImmersiveSpaceButton()
        }
        .padding()
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
