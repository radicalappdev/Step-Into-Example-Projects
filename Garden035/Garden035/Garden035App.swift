//
//  Garden035App.swift
//  Garden035
//
//  Created by Joseph Simpson on 3/3/26.
//

import SwiftUI

@main
struct Garden035App: App {
    var body: some Scene {

        // MARK: - Main Window (center)
        WindowGroup(id: "MainWindow") {
            ContentView()
        }
        .defaultSize(width: 500, height: 500)

        // MARK: - Middle Row: Leading
        WindowGroup(id: "PinkFlower") {
            Text("🌸")
                .font(.system(size: 128))
        }
        .defaultSize(CGSize(width: 300, height: 200))
        .defaultWindowPlacement { _, context in
            if let mainWindow = context.windows.first(where: { $0.id == "MainWindow" }) {
                return WindowPlacement(.leading(mainWindow))
            }
            return WindowPlacement(.none)
        }

        // MARK: - Middle Row: Trailing
        WindowGroup(id: "YellowFlower") {
            Text("🌼")
                .font(.system(size: 128))
        }
        .defaultSize(CGSize(width: 300, height: 200))
        .defaultWindowPlacement { _, context in
            if let mainWindow = context.windows.first(where: { $0.id == "MainWindow" }) {
                return WindowPlacement(.trailing(mainWindow))
            }
            return WindowPlacement(.none)
        }

        // MARK: - Top Center (above main)
        WindowGroup(id: "TopCenter") {
            Text("⬆️")
                .font(.system(size: 128))
        }
        .defaultSize(CGSize(width: 300, height: 200))
        .defaultWindowPlacement { _, context in
            if let mainWindow = context.windows.first(where: { $0.id == "MainWindow" }) {
                return WindowPlacement(.above(mainWindow))
            }
            return WindowPlacement(.none)
        }

        // MARK: - Bottom Center (below main)
        WindowGroup(id: "BottomCenter") {
            Text("⬇️")
                .font(.system(size: 128))
        }
        .defaultSize(CGSize(width: 300, height: 200))
        .defaultWindowPlacement { _, context in
            if let mainWindow = context.windows.first(where: { $0.id == "MainWindow" }) {
                return WindowPlacement(.below(mainWindow))
            }
            return WindowPlacement(.none)
        }

        // MARK: - Top Leading (leading of TopCenter)
        WindowGroup(id: "TopLeading") {
            Text("↖️")
                .font(.system(size: 128))
        }
        .defaultSize(CGSize(width: 300, height: 200))
        .defaultWindowPlacement { _, context in
            if let topWindow = context.windows.first(where: { $0.id == "TopCenter" }) {
                return WindowPlacement(.leading(topWindow))
            }
            return WindowPlacement(.none)
        }

        // MARK: - Top Trailing (trailing of TopCenter)
        WindowGroup(id: "TopTrailing") {
            Text("↗️")
                .font(.system(size: 128))
        }
        .defaultSize(CGSize(width: 300, height: 200))
        .defaultWindowPlacement { _, context in
            if let topWindow = context.windows.first(where: { $0.id == "TopCenter" }) {
                return WindowPlacement(.trailing(topWindow))
            }
            return WindowPlacement(.none)
        }
    }
}
