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
            
//            StatsSlideshowView()
//                .frame(height: 360)
//                .padding()

            PostPreview()
        }
        .padding()
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
