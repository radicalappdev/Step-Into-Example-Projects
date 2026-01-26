//
//  ContentView.swift
//  VolumeLaunchPad
//
//  Created by Joseph Simpson on 1/26/26.
//

import SwiftUI
import RealityKit
import RealityKitContent

enum AppState: String {
    case showMenu = "Menu"
    case modeA = "A"
    case modeB = "B"
}

struct ContentView: View {

    @State private var mode = AppState.showMenu
    @State private var rocket = Entity()

    var body: some View {
        RealityView { content in

            guard let scene = try? await Entity(named: "Scene", in: realityKitContentBundle) else { return }
            content.add(scene)
            guard let rocketEntity = scene.findEntity(named: "ToyRocket") else { return }
            let tapGesture = TapGesture(count: 2)
                .onEnded({
                    mode = .showMenu
                })
            let gestureComponent = GestureComponent(tapGesture)
            rocketEntity.components.set(gestureComponent)
            rocket = rocketEntity
            rocket.isEnabled = false

        } update: { content in

            rocket.isEnabled = mode == .showMenu ? false : true

        }
        .realityViewLayoutBehavior(.centered)
        // Explore other anchor points based on your needs
        .ornament(attachmentAnchor: .scene(.center),  ornament: {
            VStack (spacing: 12) {
                Text("Rocket Launchpad")
                    .font(.largeTitle)
                Text("Welcome! Explore the app")
                Button(action: {
                    mode = .modeA
                }, label: {
                    Text("Launch Mode A")
                })
                Button(action: {
                    mode = .modeB
                }, label: {
                    Text("Launch Mode B")
                })
            }
            .padding()
            .glassBackgroundEffect() // Make sure to add backing glass
            .opacity(mode == .showMenu ? 1 : 0)

        })
        .ornament(attachmentAnchor: .scene(.bottomFront),  ornament: {
            VStack (spacing: 12) {
                ToggleImmersiveSpaceButton()
            }
            .glassBackgroundEffect() // Make sure to add backing glass
            .opacity(mode == .modeB ? 1 : 0)
        })
        .debugBorder3D(.white)
    }
}

#Preview(windowStyle: .volumetric) {
    ContentView()
        .environment(AppModel())
}
