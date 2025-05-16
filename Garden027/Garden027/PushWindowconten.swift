//
//  PushWindowconten.swift
//  Garden027
//
//  Created by Joseph Simpson on 5/16/25.
//
import SwiftUI

struct PushWindowContent: View {

    @Environment(AppModel.self) private var appModel
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        // We should never see this view
        Text("Nothing to see here")
            .opacity(0)
            .persistentSystemOverlays(.hidden)
        // the only thing this view needs to do is update the app model with its open state
            .onChange(of: scenePhase, initial: true) {
                switch scenePhase {
                case .inactive, .background:
                    appModel.pushWindowOpen = false
                case .active:
                    appModel.pushWindowOpen = true
                @unknown default:
                    appModel.pushWindowOpen = false
                }
            }
    }
}
