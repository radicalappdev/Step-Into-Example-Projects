//
//  Garden021App.swift
//  Garden021
//
//  Created by Joseph Simpson on 2/18/25.
//

import SwiftUI

@main
struct Garden021App: App {

    @State private var appModel = AppModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appModel)
        }
        .windowStyle(.volumetric)

    }
}
