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
        WindowGroup {
            ContentView()
        }
        .defaultSize(width: 500, height: 500)

        WindowGroup(id: "YellowFlower") {
            Text("🌸")
                .font(.system(size: 128))
        }
        .defaultSize(CGSize(width: 300, height: 200))
        .defaultWindowPlacement { _, context in
            if let mainWindow = context.windows.first {
                return WindowPlacement(.leading(mainWindow))
            }
            return WindowPlacement(.none)
        }

        WindowGroup(id: "PinkFlower") {
            Text("🌼")
                .font(.system(size: 128))
        }
        .defaultSize(CGSize(width: 300, height: 200))
        .defaultWindowPlacement { _, context in
            if let mainWindow = context.windows.first {
                return WindowPlacement(.trailing(mainWindow))
            }
            return WindowPlacement(.none)
        }
    }
}
