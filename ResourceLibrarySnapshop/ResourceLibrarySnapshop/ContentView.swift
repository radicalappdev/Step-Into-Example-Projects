//
//  ContentView.swift
//  ResourceLibrarySnapshop
//
//  Created by Joseph Simpson on 8/7/25.
//

import SwiftUI
import RealityKit
import RealityKitContent
import WebKit

struct ContentView: View {

    var url = "https://github.com/Dave-Ed-Cast/SetMode?tab=readme-ov-file"

    var body: some View {
        VStack {
            WebView(url: URL(string: url))
        }
        .padding()
        .ornament(attachmentAnchor: .scene(.top), contentAlignment: .bottom, ornament: {
            ToggleImmersiveSpaceButton()
                .glassBackgroundEffect()
        })
//        .persistentSystemOverlays(.hidden)
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}



