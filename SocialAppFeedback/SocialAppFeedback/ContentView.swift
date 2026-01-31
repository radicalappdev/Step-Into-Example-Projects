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

                // Issue 1: I saw some usernames forced to wrap on to two lines
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

                    // Issue 2: I noticed that two of the buttons in the toolbar had hover effect shapes that did not match the shape of the button. You can fix this by creating a custom button style in SwiftUI
                    HStack(spacing: 0) {
                        Button(action: {
                            print("Left button tapped")
                        }) {
                            Label("Option 1", systemImage: "star.fill")
                                .frame(width: 100, height: 60)
                        }
                        .buttonStyle(SegmentedButtonStyle(position: .leading, fillStyle: .red))

                        Button(action: {
                            print("Right button tapped")
                        }) {
                            Label("Option 2", systemImage: "heart.fill")
                                .frame(width: 100, height: 60)
                        }
                        .buttonStyle(SegmentedButtonStyle(position: .trailing))
                    }

                }
            })
        }
    }
}

// MARK: - Segmented Button Style

enum SegmentPosition {
    case leading
    case trailing
}

struct SegmentedButtonStyle: ButtonStyle {
    let position: SegmentPosition
    let fillStyle: AnyShapeStyle
    @State private var isHovered = false
    
    init(position: SegmentPosition, fillStyle: some ShapeStyle = .thinMaterial) {
        self.position = position
        self.fillStyle = AnyShapeStyle(fillStyle)
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background {
                UnevenRoundedRectangle(
                    topLeadingRadius: position == .leading ? 12 : 0,
                    bottomLeadingRadius: position == .leading ? 12 : 0,
                    bottomTrailingRadius: position == .trailing ? 12 : 0,
                    topTrailingRadius: position == .trailing ? 12 : 0,
                    style: .continuous
                )
                .fill(fillStyle)
                .hoverEffect() // Add the hover effect to the new shape
            }
            .clipShape(
                UnevenRoundedRectangle(
                    topLeadingRadius: position == .leading ? 12 : 0,
                    bottomLeadingRadius: position == .leading ? 12 : 0,
                    bottomTrailingRadius: position == .trailing ? 12 : 0,
                    topTrailingRadius: position == .trailing ? 12 : 0,
                    style: .continuous
                )
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
