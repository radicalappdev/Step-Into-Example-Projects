//
//  WindowContent.swift
//  Garden022
//
//  Created by Joseph Simpson on 2/27/25.
//

import SwiftUI

struct WindowContent: View {

    @Environment(AppModel.self) private var appModel
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        VStack {
            Text("Window Content")

        }
        .onChange(of: scenePhase, initial: true) {
            switch scenePhase {
            case .inactive, .background:
                appModel.windowIsOpen = false
            case .active:
                appModel.windowIsOpen = true
            @unknown default:
                appModel.windowIsOpen = false
            }
        }
    }
}

#Preview {
    WindowContent()
}
