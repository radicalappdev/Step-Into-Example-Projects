//
//  ScalableLightSystem.swift
//  ScaledLightSystem
//
//  Created by Joseph Simpson on 9/9/25.
//

import RealityKit

struct ScalableLightSystem: System {
    static let query = EntityQuery(where: .has(ScalableLightComponent.self))

    init(scene: Scene) {}

    func update(context: SceneUpdateContext) {
        for entity in context.entities(matching: Self.query, updatingSystemWhen: .rendering) {
            guard var comp = entity.components[ScalableLightComponent.self] else { continue }
            guard let source = context.scene.findEntity(named: comp.scaleSourceName) else { continue }

            // derive a single scale 's' from the source
            let t = source.transform.scale
            let sRaw: Float = switch comp.nonUniformMode {
            case .average: (t.x + t.y + t.z) / 3
            case .max: max(t.x, max(t.y, t.z))
            }

            // normalize against the reference authoring scale
            let s = max(0.0001, sRaw / max(0.0001, comp.referenceScale))

            // threshold check
            if !comp.lastAppliedScale.isNaN {
                let delta = abs(s - comp.lastAppliedScale)
                if delta <= (abs(s) * comp.epsilon) { continue }
            }

            // Apply to Point/Spot lights if present
            var touched = false

            if var point = entity.components[PointLightComponent.self] {
                point.intensity = comp.baseIntensity * s * s
                point.attenuationRadius = comp.baseRadius * s
                // other properties remain as-authored
                entity.components.set(point); touched = true
            }

            if var spot = entity.components[SpotLightComponent.self] {
                spot.intensity = comp.baseIntensity * s * s
                spot.attenuationRadius = comp.baseRadius * s
                // other properties remain as-authored
                entity.components.set(spot); touched = true
            }

            if touched {
                comp.lastAppliedScale = s
                entity.components.set(comp)
            }
        }
    }
}

