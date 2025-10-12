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
    
    @Environment(AppModel.self) private var appModel
    
    var body: some View {
        @Bindable var model = appModel
        VStack {
            WebView(url: URL(string: model.urlToLoad))
            TextField("URL", text: $model.urlToLoad)
        }
        .padding()
        .ornament(attachmentAnchor: .scene(.top), contentAlignment: .bottom, ornament: {
            ToggleImmersiveSpaceButton()
                .glassBackgroundEffect()
        })
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
