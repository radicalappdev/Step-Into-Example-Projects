//
//  ContentView.swift
//  Issue_ScaledPresentations
//
//  Created by Joseph Simpson on 12/4/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    @State var enlarge = false

    var body: some View {

        RealityView { content in

            guard let scene = try? await Entity(named: "Scene", in: realityKitContentBundle) else { return }
            content.add(scene)

            guard let earth = scene.findEntity(named: "Earth") else { return }
            if let popoverAnchor = earth.findEntity(named: "EarthPopover") {
                popoverAnchor.isEnabled = false
                var presentation = PresentationComponent(
                    configuration: .popover(arrowEdge: .bottom),
                    content: EarthCard()
                )
                presentation.isPresented = false
                popoverAnchor.components.set(presentation)
            }

            let tapGesture = TapGesture()
                .onEnded({ [weak earth] _ in
                    if let popoverAnchor = earth?.findEntity(named: "EarthPopover") {
                        popoverAnchor.components[PresentationComponent.self]?.isPresented.toggle()
                    }
                })
            let gestureComponent = GestureComponent(tapGesture)
            earth.components.set(gestureComponent)

            guard let moon = scene.findEntity(named: "Moon") else { return }
            if let attachmentAnchor = moon.findEntity(named: "MoonAttachment") {
                let attachment = ViewAttachmentComponent(rootView: MoonCard())
                attachmentAnchor.components.set(attachment)
                print("found moon attachmen")
            }


        }
        .ornament(attachmentAnchor: .scene(.bottomFront), ornament: {
            VStack {
                Text("Earth & Luna")
            }
            .padding(12)
            .glassBackgroundEffect()
        })

    }
}

struct EarthCard: View {
    var body: some View {
        VStack {
            Text("Earth")
                .font(.largeTitle)
            Text("The only confirmed location in the universe that services ice cream.")
            Spacer()
            HStack {
                Button(action: {
                    print("nothing to see")
                }, label: {
                    Image(systemName: "plus")
                })
                Button(action: {
                    print("nothing to see")
                }, label: {
                    Text("Button")
                })
            }
        }
        .padding(24)
        .frame(width: 300, height:200)
    }
}

struct MoonCard: View {
    var body: some View {
        VStack {
            Text("Luna")
                .font(.largeTitle)
            Text("Made entirely of cheese")
        }
        .padding(24)
        .frame(width: 200, height: 160)
        .glassBackgroundEffect()
    }
}

#Preview(windowStyle: .volumetric) {
    ContentView()
}
