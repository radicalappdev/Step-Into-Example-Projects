//
//  ContentView.swift
//  Garden035
//
//  Created by Joseph Simpson on 3/3/26.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    @Environment(\.openWindow) var openWindow
    @Environment(\.dismissWindow) var dismissWindow
    @State private var secondaryWindowsOpen = false

    var body: some View {
        VStack(spacing: 12) {
            Text("Window Garden")
                .font(.largeTitle)

            Button(action: {
                secondaryWindowsOpen.toggle()
            }, label: {
                Label("\(self.secondaryWindowsOpen ? "Hide" : "Show") Windows", systemImage: "inset.filled.center.rectangle.badge.plus")
            })
        }
        .padding()
        .onChange(of: secondaryWindowsOpen) { _, newValue in
            if newValue {
                openWindow(id: "YellowFlower")
                openWindow(id: "PinkFlower")
            } else {
                dismissWindow(id: "YellowFlower")
                dismissWindow(id: "PinkFlower")
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
