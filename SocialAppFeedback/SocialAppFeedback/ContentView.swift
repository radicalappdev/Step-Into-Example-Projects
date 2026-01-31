//
//  ContentView.swift
//  SocialAppFeedback
//
//  Created by Joseph Simpson on 1/31/26.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    var body: some View {
        HStack(spacing: 24) {
            Color.black
                .clipShape(.rect(cornerRadius: 24))
                .frame(width: 300)
            Color.black
                .clipShape(.rect(cornerRadius: 24))
                .frame(width: 500)

            VStack {

                // Issue 1: I saw some usernames forced to tap into two lines
                Text("@somelongusername❌") // ❌ Can break across lines
                    .font(.largeTitle)
                Text("@somelongusername✅") // ✅ This will scale the username down to fit within the region
                    .font(.largeTitle)
                    .lineLimit(1) // Forces the text onto a single line
                    .minimumScaleFactor(0.5) // Allows the text to shrink to 50% of its original size. Adjus this as needed
                Spacer()
            }
            .frame(width: 220) // Constrains the width for demonstration
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .bottomOrnament, content: {
                HStack(spacing: 12) {
                    Color.black
                        .clipShape(.rect(cornerRadius: 24))
                        .frame(width: 200, height: 60)
                    Color.black
                        .clipShape(.circle)
                        .frame(width: 44, height: 44)

                }
            })
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
