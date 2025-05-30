//
//  ImmersiveView.swift
//  Pride2025
//
//  Created by Joseph Simpson on 5/29/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {

    @PhysicalMetric(from: .meters) var triangleSize: CGFloat = 1
    @PhysicalMetric(from: .meters) var moonSize: CGFloat = 1

    var body: some View {
        RealityView { content, attachments in

            if let scene = try? await Entity(named: "Immersive", in: realityKitContentBundle) {
                content.add(scene)

                if let hearts1 = scene.findEntity(named: "Hearts1") {
                    if var pe = hearts1.components[ParticleEmitterComponent.self] {
                        pe.mainEmitter.image = generateTextureFromSystemName("heart.fill")
                        hearts1.components.set(pe)
                    }
                }

                if let hearts2 = scene.findEntity(named: "Hearts2") {
                    if var pe = hearts2.components[ParticleEmitterComponent.self] {
                        pe.mainEmitter.image = generateTextureFromSystemName("heart.fill")
                        hearts2.components.set(pe)
                    }
                }

                let triangles = Entity()
                content.add(triangles)
                triangles.position = [-3, 3, -4]
                if let triMagenta = attachments.entity(for: "triMagenta") {
                    triangles.addChild(triMagenta)
                    triMagenta.setPosition([-0.25, 0.25, -0.1], relativeTo: triangles)
                }
                if let triBlue = attachments.entity(for: "triBlue") {
                    triangles.addChild(triBlue)
                    triBlue.setPosition([0.25, 0, 0], relativeTo: triangles)
                }

                if let moons = attachments.entity(for: "moons") {
                    content.add(moons)
                    moons.position = [3, 3, -4]
                }

                if let bisexuals = attachments.entity(for: "bisexuals") {
                    content.add(bisexuals)
                    bisexuals.position = [0, 3, -3]
                }

            }
        } update: { content, attachments in
        } attachments: {
            Attachment(id: "triMagenta", {
                Triangle()
                    .foregroundStyle(.biMagenta)
                    .opacity(0.8)
                    .frame(width: triangleSize, height: triangleSize)
            })

            Attachment(id: "triBlue", {
                Triangle()
                    .foregroundStyle(.biRoyalBlue)
                    .opacity(0.8)
                    .frame(width: triangleSize, height: triangleSize)
            })


            Attachment(id: "moons", {
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [.biMagenta, .biPurple, .biRoyalBlue]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .mask(
                        ZStack {
                            Image(systemName: "moon.fill")
                                .rotationEffect(Angle(degrees: 224))
                                .offset(x: -340, y: -200)

                            Image(systemName: "moon.fill")
                                .rotationEffect(Angle(degrees: 34))
                                .offset(x: 340, y: 200)
                        }
                            .frame(width: moonSize, height: moonSize)
                            .font(.system(size: 944, weight: .light))
                    )
                }
                .frame(width: moonSize, height: moonSize)

            })

            Attachment(id: "bisexuals", {
                Text("Bisexuals have always existed.")
                    .font(.system(size: 366, weight: .heavy))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [.biMagenta, .biPurple, .biRoyalBlue]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 2000, height: 2000)
            })
        }
    }

    // Credit: Apple provided this function in the example project called "Simulating particles in your visionOS app"
    // Sources: https://developer.apple.com/documentation/realitykit/simulating-particles-in-your-visionos-app
    func generateTextureFromSystemName( _ name: String) -> TextureResource? {
        // Create a UIImage from a symbol name.
        guard var symbolImage = UIImage(systemName: name) else {
            return nil
        }

        // Create a new version that always uses the template rendering mode.
        symbolImage = symbolImage.withRenderingMode(.alwaysTemplate)

        // Get the natural size of the symbol
        let symbolSize = symbolImage.size

        // Create a square texture
        let textureSize: CGFloat = 128
        let imageSize = CGSize(width: textureSize, height: textureSize)

        // Calculate the aspect ratio and scaled size
        let aspectRatio = symbolSize.width / symbolSize.height
        let scaledSize: CGSize
        if aspectRatio > 1 {
            // Wider than tall
            scaledSize = CGSize(width: textureSize, height: textureSize / aspectRatio)
        } else {
            // Taller than wide or square
            scaledSize = CGSize(width: textureSize * aspectRatio, height: textureSize)
        }

        // Calculate the position to center the symbol
        let x = (textureSize - scaledSize.width) / 2
        let y = (textureSize - scaledSize.height) / 2
        let drawRect = CGRect(origin: CGPoint(x: x, y: y), size: scaledSize)

        // Start the graphics context.
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)

        // Set the color's texture to white so that the app can apply a color
        // on top of the image.
        UIColor.white.set()

        // Draw the image with the context, centered in the square
        symbolImage.draw(in: drawRect, blendMode: .normal, alpha: 1.0)

        // Retrieve the image from the context.
        let contextImage = UIGraphicsGetImageFromCurrentImageContext()

        // End the graphics context.
        UIGraphicsEndImageContext()

        // Retrieve the Core Graphics version of the image.
        guard let coreGraphicsImage = contextImage?.cgImage else {
            return nil
        }

        // Generate the texture resource from the Core Graphics image.
        let creationOptions = TextureResource.CreateOptions(semantic: .raw)
        return try? TextureResource(image: coreGraphicsImage,
                                    options: creationOptions)
    }
}

//#Preview(immersionStyle: .full) {
//    ImmersiveView()
//        .environment(AppModel())
//}


struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.midX, y: rect.maxY)) // tip at bottom
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY)) // left corner at top
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY)) // right corner at top
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY)) // close the path

        return path
    }
}

