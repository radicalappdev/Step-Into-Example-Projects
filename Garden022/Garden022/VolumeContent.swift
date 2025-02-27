//
//  VolumeContent.swift
//  Garden022
//
//  Created by Joseph Simpson on 2/27/25.
//

import SwiftUI

struct VolumeContent: View {

    @Environment(AppModel.self) private var appModel
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        VStack {
            Text("Volume Content")

        }
        .onChange(of: scenePhase, initial: true) {
            switch scenePhase {
            case .inactive, .background:
                appModel.volumeIsOpen = false
            case .active:
                appModel.volumeIsOpen = true
            @unknown default:
                appModel.volumeIsOpen = false
            }
        }
    }
}

#Preview {
    VolumeContent()
}
