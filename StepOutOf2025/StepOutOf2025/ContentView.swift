//
//  ContentView.swift
//  StepOutOf2025
//
//  Created by Joseph Simpson on 12/31/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    var body: some View {
        VStack {
//            Model3D(named: "Scene", bundle: realityKitContentBundle)
//                .padding(.bottom, 50)
//
//            Text("Hello, world!")

//            ToggleImmersiveSpaceButton()
            
//            Spacer().frame(height: 24)
            
            StatsSlideshowView()
                .frame(height: 360)
                .padding()
        }
        .padding()
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
