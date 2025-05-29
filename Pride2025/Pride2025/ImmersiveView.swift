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

    @PhysicalMetric(from: .meters) var textSize: CGFloat = 1

    var body: some View {
        RealityView { content, attachments in
            // Add the initial RealityKit content
            if let immersiveContentEntity = try? await Entity(named: "Immersive", in: realityKitContentBundle) {
                content.add(immersiveContentEntity)

                let triangles = Entity()
                content.add(triangles)
                triangles.position = [-3, 3, -6]
                if let triMagenta = attachments.entity(for: "triMagenta") {
                    triangles.addChild(triMagenta)
                    triMagenta.setPosition([-0.25, 0.25, -0.1], relativeTo: triangles)
                }
                if let triBlue = attachments.entity(for: "triBlue") {
                    triangles.addChild(triBlue)
                    triBlue.setPosition([0.25, 0, 0], relativeTo: triangles)
                }

                if let bisexuals = attachments.entity(for: "bisexuals") {
                    content.add(bisexuals)
                    bisexuals.position = [3, 3, -6]
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

            Attachment(id: "bisexuals", {
                Text("Bisexuals have always existed.")
                    .font(.system(size: 288, weight: .heavy))
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

