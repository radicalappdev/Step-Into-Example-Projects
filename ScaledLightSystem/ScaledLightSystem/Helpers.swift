//
//  Helpers.swift
//  ScaledLightSystem
//
//  Created by Joseph Simpson on 9/9/25.
//

import SwiftUI
import RealityKit

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

        self.scale = [scaleX, scaleY, scaleZ]
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
