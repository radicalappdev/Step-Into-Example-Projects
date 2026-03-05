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
    @State private var autoManageSecondaryWindows = true

    /// World Position isn't strictly necessary. We are just using this to display the current world position of the main window.
    @State private var worldPosiiton: Point3D = .zero
    @State private var movementEndTimer: Timer?
    @State private var isMoving = false

    var body: some View {
        VStack(spacing: 12) {
            Text("Window Garden")
                .font(.largeTitle)

            Button(action: {
                autoManageSecondaryWindows.toggle()
            }, label: {
                Label("Secondary Windows: \(autoManageSecondaryWindows ? "Auto" : "Manual")", systemImage: autoManageSecondaryWindows ? "bolt.badge.automatic" : "hand.tap"
                )
            })

            Vector3Display(title: "World Position", vector: worldPosiiton)
                .padding()

        }
        .padding()

        .onChange(of: secondaryWindowsOpen) { oldValue, newValue in


            if newValue {
                // Open middle row first
                openWindow(id: "MiddleLeading")
                openWindow(id: "MiddleTrailing")
                // Open top center before its neighbors
                openWindow(id: "TopCenter")
                openWindow(id: "BottomCenter")
                // Delay corner windows so TopCenter is registered in context.windows
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    openWindow(id: "TopLeading")
                    openWindow(id: "TopTrailing")
                }
            } else {
                // Dismiss corner windows first
                dismissWindow(id: "TopLeading")
                dismissWindow(id: "TopTrailing")
                // Then the rest
                dismissWindow(id: "TopCenter")
                dismissWindow(id: "BottomCenter")
                dismissWindow(id: "MiddleLeading")
                dismissWindow(id: "MiddleTrailing")
            }
        }
        .onChange(of: autoManageSecondaryWindows) { oldValue, newValue in
            // When enabling Auto mode, ensure secondary windows are open
            if newValue && !secondaryWindowsOpen {
                secondaryWindowsOpen = true
            }
        }
        .onGeometryChange3D(for: Point3D.self) { proxy in try! proxy
                .coordinateSpace3D()
                .convert(value: Point3D.zero, to: .worldReference)
        } action: { old, new in
            worldPosiiton = new

            // Mark as moving when a new change arrives
            if !isMoving {
                isMoving = true
                // Special: movement began
                print("🟢 Window movement began at \(worldPosiiton)")
                if autoManageSecondaryWindows {
                    secondaryWindowsOpen = false
                }
            }

            // Reset debounce timer; when it fires, consider movement ended
            movementEndTimer?.invalidate()
            movementEndTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
                isMoving = false
                // This is your "stopped moving" event
                print("🛑 Window movement stopped at \(worldPosiiton)")
                if autoManageSecondaryWindows {
                    secondaryWindowsOpen = true
                }
            }
        }
        .onDisappear {
            movementEndTimer?.invalidate()
            movementEndTimer = nil
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



