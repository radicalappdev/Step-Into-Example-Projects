//
//  ContentView.swift
//  Garden035
//
//  Created by Joseph Simpson on 3/3/26.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    @Environment(\.openWindow) var openWindow
    @Environment(\.dismissWindow) var dismissWindow
    @State private var secondaryWindowsOpen = false

    @State private var worldPosiiton: Point3D = .zero

    var body: some View {
        VStack(spacing: 12) {
            Text("Window Garden")
                .font(.largeTitle)

            Button(action: {
                secondaryWindowsOpen.toggle()
            }, label: {
                Label("\(self.secondaryWindowsOpen ? "Hide" : "Show") Windows", systemImage: "inset.filled.center.rectangle.badge.plus")
            })

            Vector3Display(title: "World Position", vector: worldPosiiton)
                .padding()

        }
        .padding()
        .onChange(of: secondaryWindowsOpen) { _, newValue in
            if newValue {
                openWindow(id: "YellowFlower")
                openWindow(id: "PinkFlower")
            } else {
                dismissWindow(id: "YellowFlower")
                dismissWindow(id: "PinkFlower")
            }
        }
        .onGeometryChange3D(for: Point3D.self) { proxy in try! proxy
                .coordinateSpace3D()
                .convert(value: Point3D.zero, to: .worldReference)
        } action: { old, new in
            worldPosiiton = new
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}


struct Vector3Display: View {
    let title: String
    let vector: Point3D

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .fontWeight(.bold)

            HStack {
                ForEach(["X", "Y", "Z"], id: \.self) { axis in
                    let value = axis == "X" ? vector.x : axis == "Y" ? vector.y : vector.z
                    HStack {
                        Text("\(axis):")
                            .fontWeight(.bold)
                        Text(String(format: "%2.3f", value.isNaN ? 0 : value))
                    }
                    .frame(width: 150, alignment: .leading)
                }
            }
        }
    }
}
