//
//  ContentView.swift
//  Garden032
//
//  Created by Joseph Simpson on 9/1/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    /// A top level entity that will be scaled with the volume. Only the root view will be added to this
    @State private var volumeRootEntity = Entity()

    var body: some View {
        GeometryReader3D { proxy in
            RealityView { content in

                content.add(volumeRootEntity)

                /// A root view for the graveyard content.  All other entities will be added to this.
                guard let baseRoot = try? await Entity(named: "Scene", in: realityKitContentBundle) else { return }
                baseRoot.name = "TableScene"
                baseRoot.position = [0, -0.45, 0] // Move this down to the bottom of the volume
                volumeRootEntity.addChild(baseRoot, preservingWorldTransform: true)



            } update: { content in

                volumeRootEntity.scaleWithVolume(content, proxy)
                print("Update closure called. current scale: \(volumeRootEntity.scale.x)")

            }
            .debugBorder3D(.white)

        }
    }
}

extension Entity {

    /// Based on an article by Drew Olbrich
    // see [If you've created a visionOS app with a volume, you probably did it wrong](https://www.lunarskydiving.com/blog/volume-window-zoom/)
    /// - Parameters:
    ///   - realityViewContent: The RealityView content providing coordinate conversion context
    ///   - geometryProxy3D: The 3D geometry proxy containing the volume's frame information
    ///   - defaultVolumeSize: The expected volume size in meters. Defaults to 1.1x1.1x1.1 to provide 10% padding around content
    @MainActor func scaleWithVolume(
        _ realityViewContent: RealityViewContent,
        _ geometryProxy3D: GeometryProxy3D,
        _ defaultVolumeSize: Size3D = Size3D(width: 1.1, height: 1.1, depth: 1.1)
    ) {

        /// The bounding box of the volume's contents, in meters.
        ///
        /// This value will only equal `defaultVolumeSize` if the preferred display size
        /// selected by the user with **Settings > Display > Appearance** happens to be
        /// Large, which is the default value for visionOS 1.0.
        let scaledVolumeContentBoundingBox = realityViewContent.convert(geometryProxy3D.frame(in: .local), from: .local, to: .scene)


        let scaleX = scaledVolumeContentBoundingBox.extents.x / Float(defaultVolumeSize.width)
        let scaleY = scaledVolumeContentBoundingBox.extents.y / Float(defaultVolumeSize.height)
        let scaleZ = scaledVolumeContentBoundingBox.extents.z / Float(defaultVolumeSize.depth)

        /// Note that a GeometryProxy3D will trigger an update to RealityView when the user *moves* the a Volume. Not just when they resize it, when they move it.
        /// We can check the scale difference to avoid unnecessary updates
        let newScale: SIMD3<Float> = [scaleX, scaleY, scaleZ]
        let scaleDifference = abs(newScale.x - self.scale.x)

        if scaleDifference > 0.001 { // Only update if change is significant
            self.scale = newScale
            print("scalling to \(newScale)")
        }

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



