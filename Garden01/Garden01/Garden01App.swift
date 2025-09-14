//
//  Garden01App.swift
//  Garden01
//
//  Created by Joseph Simpson on 7/28/24.
//

import SwiftUI

@main
struct Garden01App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        WindowGroup(id: "YellowFlower") {
            YellowFlowerView()
        }

        Window("Unique Rose Window", id: "RoseWindow") {
            RoseFlowerView()
        }
    }
}
