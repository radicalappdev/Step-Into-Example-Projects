//
//  ContentView.swift
//  Garden022
//
//  Created by Joseph Simpson on 2/27/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    @Environment(AppModel.self) private var appModel

    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow

    var body: some View {
        VStack {

            Text("Where is (0, 0, 0) in each scene?")

            Button(action: {
                if appModel.windowIsOpen {
                    dismissWindow(id: "WindowExample")
                } else {
                    openWindow(id: "WindowExample")
                }
            }, label: {
                HStack {
                    Text(appModel.windowIsOpen ? "Hide Window" : "Show Window")
                }
            })

            Button(action: {
                if appModel.volumeIsOpen {
                    dismissWindow(id: "VolumeExample")
                } else {
                    openWindow(id: "VolumeExample")
                }
            }, label: {
                HStack {
                    Text(appModel.volumeIsOpen ? "Hide Volume" : "Show Volume")
                }
            })

            ToggleImmersiveSpaceButton()
        }
        .padding()
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
