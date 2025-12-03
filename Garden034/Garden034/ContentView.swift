//
//  ContentView.swift
//  Garden034
//
//  Created by Joseph Simpson on 12/2/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    /// We'll need to use a converter from physicalMetrics
    @Environment(\.physicalMetrics) var physicalMetrics

    /// This will store the size of the volume
    @State private var volumeSize: Size3D = .zero

    /// A top level entity that will be scaled with the volume. Only the root view will be added to this
    @State private var volumeRootEntity = Entity()

    // A place to store the bounds of our 3D content
    @State private var baseExtents: SIMD3<Float> = .zero

    var body: some View {
        RealityView { content in
            content.add(volumeRootEntity)

            /// Load a scene from Reality Composer Pro and add it to volumeRootEntity
            guard let baseRoot = try? await Entity(named: "Scene", in: realityKitContentBundle) else { return }
            baseRoot.name = "TableScene"
            baseRoot.position = [0, -0.45, 0] // Move this down to the bottom of the volume
            volumeRootEntity.addChild(baseRoot, preservingWorldTransform: true)

            // Capture the base extents from visual bounds
            baseExtents = baseRoot.visualBounds(relativeTo: nil).extents / baseRoot.scale

            // Call our new function once for the initial size
            scaleContent(by: volumeSize)
        }
        .debugBorder3D(.white)
        // Anytime the volume changes in size we'll scale the RealityView content
        .onGeometryChange3D(for: Rect3D.self) { proxy in
            return proxy.frame(in: .global)
        } action: { new in
            volumeSize = new.size
            scaleContent(by: volumeSize)
        }
    }

    /// Scale the 3D content based on the size of the Volume
    func scaleContent(by volumeSize: Size3D) {
        let scale = Float(physicalMetrics.convert(volumeSize.width, to: .meters)) / baseExtents.x
        volumeRootEntity.setScale(.init(repeating: scale), relativeTo: nil)
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

#Preview(windowStyle: .volumetric) {
    ContentView()
}

