//
//  Garden028App.swift
//  Garden028
//
//  Created by Joseph Simpson on 6/24/25.
//

import SwiftUI

@main
struct Garden028App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .defaultSize(width: 500, height: 500)

        WindowGroup(id: "UtilityWindow", makeContent: {
            UtilityRoot()
        })

        .restorationBehavior(.disabled)
        .defaultLaunchBehavior(.suppressed)
        .defaultSize(CGSize(width: 300, height: 200))
        .defaultWindowPlacement { _, context in
            if let mainWindow = context.windows.first {
                return WindowPlacement(.trailing(mainWindow))
            }
            return WindowPlacement(.none)
        }

        

    }
}
