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
        WindowGroup(id: "MiddleLeading") {
            Text("⬅️")
                .font(.system(size: 128))
                .persistentSystemOverlays(.hidden)
        }
        .defaultSize(CGSize(width: 300, height: 500))
        .defaultWindowPlacement { _, context in
            if let mainWindow = context.windows.first(where: { $0.id == "MainWindow" }) {
                return WindowPlacement(.leading(mainWindow))
            }
            return WindowPlacement(.none)
        }

        // MARK: - Middle Row: Trailing
        WindowGroup(id: "MiddleTrailing") {
            Text("➡️")
                .font(.system(size: 128))
                .persistentSystemOverlays(.hidden)
        }
        .defaultSize(CGSize(width: 300, height: 500))
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
                .persistentSystemOverlays(.hidden)
        }
        .defaultSize(CGSize(width: 500, height: 300))
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
                .persistentSystemOverlays(.hidden)
        }
        .defaultSize(CGSize(width: 1200, height: 300))
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
                .persistentSystemOverlays(.hidden)
        }
        .defaultSize(CGSize(width: 300, height: 300))
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
                .persistentSystemOverlays(.hidden)
        }
        .defaultSize(CGSize(width: 300, height: 300))
        .defaultWindowPlacement { _, context in
            if let topWindow = context.windows.first(where: { $0.id == "TopCenter" }) {
                return WindowPlacement(.trailing(topWindow))
            }
            return WindowPlacement(.none)
        }
    }
}
