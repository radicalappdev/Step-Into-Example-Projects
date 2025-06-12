//
//  LoomingGradientWidget.swift
//  StepWidgetTests
//
//  Created by Joseph Simpson on 6/12/25.
//

import SwiftUI


struct LoomingGradient: View {


    var body: some View {
        let colorTint: Color = .red
        let colorMix: Color = .black

        MeshGradient(
            width: 3, height: 3,
            points: [
                .init(0, 0), .init(0.5, 0), .init(1, 0),
                .init(0.2, 0.5), .init(0.5, 0.5), .init(0.8, 0.5),
                .init(0, 1), .init(0.5, 1), .init(1, 1),
            ],
            colors: [
                colorTint,
                colorMix.mix(with: colorTint, by: 0.25),
                colorTint,
                colorMix.mix(with: colorTint, by: -0.25),
                colorTint,
                colorMix.mix(with: colorTint, by: 0.6),
                colorTint,
                colorMix.mix(with: colorTint, by: 0.3),
                colorTint,
            ]
        )

    }
}

