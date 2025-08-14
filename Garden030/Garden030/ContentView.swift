//
//  ContentView.swift
//  Garden030
//
//  Created by Joseph Simpson on 8/13/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    @Environment(\.windowClippingMargins) private var windowClippingMargins
    @PhysicalMetric(from: .meters) private var points = 1

    @State private var length: CGFloat = 0
    @State private var edges: Edge3D.Set = [.top, .leading, .bottom, .trailing, .back]
    @State private var shouldScaleContent = false

    var body: some View {
        VStack {
            RealityView { content in

                if let scene = try? await Entity(named: "Scene", in: realityKitContentBundle) {
                    content.add(scene)
                }
                         } update: { content in
                 if let scene = content.entities.first {

                     if(!shouldScaleContent) {
                         scene.scale = .init(repeating: 0.5)
                         return
                     }

                     // Use the actual windowClippingMargins from environment
                     // When no margins, we want scale 0.5 (default)
                     // When margins exist, scale up to fill the extra space
                     let baseScale: Float = 0.5
                     
                     // We using the same margin on all sides, so just read one of them
                     let margin = windowClippingMargins.top

                     // Scale up based on available margin space
                     let marginScale = Float(margin / points)
                     let scaleFactor = baseScale + marginScale
                     
                     print("maxMargin: \(margin), marginScale: \(marginScale), scaleFactor: \(scaleFactor)")
                     scene.scale = .init(repeating: scaleFactor)

                 }

             }
        }
        .preferredWindowClippingMargins(edges, length)
        .debugBorder3D(.white)
        .toolbar {
            ToolbarItem(placement: .bottomOrnament, content: {
                HStack {

                    HStack {
                        EdgeToggleButton(edge: .top, label: "Top", edges: $edges)
                        EdgeToggleButton(edge: .bottom, label: "Bottom", edges: $edges)
                        EdgeToggleButton(edge: .leading, label: "Leading", edges: $edges)
                        EdgeToggleButton(edge: .trailing, label: "Trailing", edges: $edges)
                        EdgeToggleButton(edge: .back, label: "Back", edges: $edges)
                    }

                    Divider()

                    // 640 seems to be the max as of visionOS 26 beta 6
                    Slider(value: $length, in: 0...640, label: {
                        Text("Length")
                    })
                    .frame(width: 200)

                    Button(action: {
                        shouldScaleContent.toggle()
                    }, label: {
                        Label("Scale", systemImage: shouldScaleContent ? "circle.circle.fill" : "circle")
                            .labelStyle(.titleAndIcon)
                    })
                }
            })
        }
    }
}

struct EdgeToggleButton: View {
    let edge: Edge3D.Set
    let label: String
    @Binding var edges: Edge3D.Set
    
    var body: some View {
        Button(action: {
            if edges.contains(edge) {
                edges.remove(edge)
            } else {
                edges.insert(edge)
            }
        }, label: {
            Label(label, systemImage: edges.contains(edge) ? "circle.circle.fill" : "circle")
                .labelStyle(.titleAndIcon)
        })
    }
}


/// See WWDC 2025 Session: Meet SwiftUI spatial layout
/// https://developer.apple.com/videos/play/wwdc2025/273
extension View {
    func debugBorder3D(_ color: Color) -> some View {
        spatialOverlay {
            ZStack {
                Color.clear.border(color, width: 4)
                ZStack {
                    Color.clear.border(color, width: 4)
                    Spacer()
                    Color.clear.border(color, width: 4)
                }
                .rotation3DLayout(.degrees(90), axis: .y)
                Color.clear.border(color, width: 4)
            }
        }
    }
}
