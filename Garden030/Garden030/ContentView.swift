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

    @State private var length: CGFloat = 0

    @State private var edges: Edge3D.Set = [.top, .leading, .bottom, .trailing, .back]

    var body: some View {
        VStack {
            RealityView { content in

                if let scene = try? await Entity(named: "Scene", in: realityKitContentBundle) {
                    content.add(scene)
                }
            }
            .preferredWindowClippingMargins(edges, length)
            .debugBorder3D(.white)
        }
        .toolbar {
            ToolbarItem(placement: .bottomOrnament, content: {
                HStack {

                    HStack {
                        Button("Top") {
                            if edges.contains(.top) {
                                edges.remove(.top)
                            } else {
                                edges.insert(.top)
                            }
                        }
                        
                        Button("Bottom") {
                            if edges.contains(.bottom) {
                                edges.remove(.bottom)
                            } else {
                                edges.insert(.bottom)
                            }
                        }
                        
                        Button("Leading") {
                            if edges.contains(.leading) {
                                edges.remove(.leading)
                            } else {
                                edges.insert(.leading)
                            }
                        }
                        
                        Button("Trailing") {
                            if edges.contains(.trailing) {
                                edges.remove(.trailing)
                            } else {
                                edges.insert(.trailing)
                            }
                        }
                        
                        Button("Back") {
                            if edges.contains(.back) {
                                edges.remove(.back)
                            } else {
                                edges.insert(.back)
                            }
                        }
                    }

                    Divider()

                    Slider(value: $length, in: 0...1000, label: {
                        Text("Length")
                    })
                    .frame(width: 200)
                }
            })
        }
    }
}

#Preview(windowStyle: .volumetric) {
    ContentView()
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
