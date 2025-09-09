//
//  ScalableLightComponent.swift
//  ScaledLightSystem
//
//  Created by Joseph Simpson on 9/9/25.
//

import RealityKit

struct ScalableLightComponent: Component, Codable, Hashable {
    /// Base intensity at referenceScale = 1.0
    /// Will by multiplied by × scale²
    var baseIntensity: Float = 1500

    /// Base radius at referenceScale = 1.0
    /// Will by multiplied by × scale²
    var baseRadius: Float = 6

    /// Name of the entity whose (uniform) scale we watch (e.g. your volume root)
    var scaleSourceName: String

    /// Reference scale at which base* values were authored
    var referenceScale: Float = 1.0

    /// Minimum relative change in scale before recalculating light values.
    /// This avoids constant updates from tiny scale fluctuations (floating-point jitter or micro resize events).
    /// For example, epsilon = 0.02 means the light only updates when the scale changes more than ~2% compared to the last applied value.
    var epsilon: Float = 0.02

    /// How to collapse non-uniform scale into one value
    enum NonUniformMode: String, Codable { case average, max }
    var nonUniformMode: NonUniformMode = .average

    // cache the last used scale
    var lastAppliedScale: Float = .nan
}

