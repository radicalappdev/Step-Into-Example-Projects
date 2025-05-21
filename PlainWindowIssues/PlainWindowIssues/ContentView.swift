//
//  ContentView.swift
//  PlainWindowIssues
//
//  Created by Joseph Simpson on 5/19/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    var body: some View {
        NavigationStack {
            VStack {
                Model3D(named: "Scene", bundle: realityKitContentBundle)
                    .padding(.bottom, 50)

                Text("Hello, world!")

                ToggleImmersiveSpaceButton()

            }
        }
        
        // Has no effect on the navigation stack
        .glassBackgroundEffect(displayMode: .never)
        .padding()
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
