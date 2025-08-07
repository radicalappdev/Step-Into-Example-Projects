//
//  ImmersiveView.swift
//  ResourceLibrarySnapshop
//
//  Created by Joseph Simpson on 8/7/25.
//

import SwiftUI
import RealityKit
import RealityKitContent
import WebKit

struct AttachmentView: View {

    var url = "https://github.com/XanderXu/RealityShaderExtension"

    var body: some View {
        VStack {
            WebView(url: URL(string: url))
        }
        .frame(width: 1200, height: 800)
    }
}

struct ImmersiveView: View {

    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            if let immersiveContentEntity = try? await Entity(named: "Immersive", in: realityKitContentBundle) {
                content.add(immersiveContentEntity)

                // Put skybox here.  See example in World project available at
                // https://developer.apple.com/

                let avp = createParticleEntity(systemImage: "vision.pro.fill")
                content.add(avp)
                let mac = createParticleEntity(systemImage: "macbook.gen2")
                mac.position = [-0.25, 0.5, 0]
                content.add(mac)

                let webView = Entity()
                webView.name = "WebView"
                webView.position = [-0.25, 1.6, -1.6]
                webView.scale = .init(repeating: 2)
                content.add(webView)

                let attachment = ViewAttachmentComponent(rootView: AttachmentView())
                webView.components.set(attachment)

                
            }
        }
    }

    func createParticleEntity(systemImage: String) -> Entity {
        let entity = Entity()
        entity.name = systemImage


        // Create the particle emitter
        var particleSystem = ParticleEmitterComponent()
        particleSystem.isEmitting = true
        particleSystem.speed = 0.01
        particleSystem.emitterShape = .sphere
        particleSystem.emitterShapeSize = [5, 5, 5]

        // Set the image to the result of generateTextureFromSystemName using a symbol name
        particleSystem.mainEmitter.image = generateTextureFromSystemName(systemImage)
        particleSystem.mainEmitter.birthRate = 100
        particleSystem.mainEmitter.size = 0.1
        particleSystem.mainEmitter.color = .constant(.single(.white))
        particleSystem.mainEmitter.sizeMultiplierAtEndOfLifespan = 1

        // Add the component to the entity
        entity.components.set(particleSystem)
        return entity
    }

    func generateTextureFromSystemName( _ name: String) -> TextureResource? {
        // Create a UIImage from a symbol name.
        guard var symbolImage = UIImage(systemName: name) else {
            return nil
        }

        // Create a new version that always uses the template rendering mode.
        symbolImage = symbolImage.withRenderingMode(.alwaysTemplate)

        // Get the natural size of the symbol
        let symbolSize = symbolImage.size
        print("symbol size \(symbolSize)")

        // Create a square texture
        let textureSize: CGFloat = 128
        let imageSize = CGSize(width: textureSize, height: textureSize)

        // Calculate the aspect ratio and scaled size
        let aspectRatio = symbolSize.width / symbolSize.height
        print("aspect ratio \(aspectRatio)")
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
        print("draw rect \(drawRect)")

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

#Preview(immersionStyle: .full) {
    ImmersiveView()
        .environment(AppModel())
}
