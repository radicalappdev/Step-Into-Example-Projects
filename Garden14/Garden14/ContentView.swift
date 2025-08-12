//
//  ContentView.swift
//  Garden14
//
//  Created by Joseph Simpson on 11/22/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    @Environment(AppModel.self) private var appModel

    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace

    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        VStack(spacing: 18) {

            Text("🫧")
                .font(.extraLargeTitle2)
            Text("Bubble Garden")
                .font(.title)
            Text("Immersive Spaces")
                .font(.extraLargeTitle)

            Text("A space is open: \(appModel.immersiveSpaceActive ? "Yes" : "No")")
                .font(.system(size: 24))

            ImmersiveSpaceButton(
                isOpen: appModel.gardenMixedOpen,
                spaceID: "GardenSceneMixed",
                label: "Mixed"
            )
            ImmersiveSpaceButton(
                isOpen: appModel.gardenProgressiveOpen,
                spaceID: "GardenSceneProgressive",
                label: "Progressive Landscale"
            )

            ImmersiveSpaceButton(
                isOpen: appModel.gardenProgressiveAltOpen,
                spaceID: "GardenSceneProgressiveAlt",
                label: "Progressive Portrait"
            )
            ImmersiveSpaceButton(
                isOpen: appModel.gardenFullOpen,
                spaceID: "GardenSceneFull",
                label: "Full"
            )

            VStack {
                Divider()
                Text("Upper Limbs: \(appModel.upperLimpVis)")

                HStack {
                    Button(action: {
                        appModel.upperLimpVis = .hidden
                    }, label: {
                        Text("Hide")
                    })
                    Button(action: {
                        appModel.upperLimpVis = .visible
                    }, label: {
                        Text("Show")
                    })
                    Spacer()
                    Button(action: {
                        appModel.upperLimpVis = .automatic
                    }, label: {
                        Text("Automatic 🤷🏻‍♂️")
                    })

                }
            }
            .opacity(appModel.immersiveSpaceActive ? 1 : 0)

        }
        .padding()
        .onChange(of: scenePhase, initial: true) {
            switch scenePhase {
            case .inactive, .background:
                appModel.mainWindowOpen = false
            case .active:
                appModel.mainWindowOpen = true
            @unknown default:
                appModel.mainWindowOpen = false
            }
        }
    }
}

struct ImmersiveSpaceButton: View {
    let isOpen: Bool
    let spaceID: String
    let label: String

    @Environment(AppModel.self) private var appModel
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace

    var body: some View {
        Button(action: {
            Task {
                if appModel.immersiveSpaceActive {
                    await dismissImmersiveSpace()
                }
                if !isOpen {
                    await openImmersiveSpace(id: spaceID)
                }
            }
        }, label: {
            Text(isOpen ? "Close \(label) Space" : "Open \(label) Space")
        })
    }
}
