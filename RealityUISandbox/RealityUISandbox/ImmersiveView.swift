//
//  ImmersiveView.swift
//  RealityUISandbox
//
//  Created by Joseph Simpson on 6/29/25.
//

import SwiftUI
import RealityKit
import RealityKitContent
import RealityUI

struct ImmersiveView: View {

    init() {
        RealityUI.registerComponents()
    }

    @State var toggleSwitchValue: Bool = false

    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            if let immersiveContentEntity = try? await Entity(named: "Immersive", in: realityKitContentBundle) {
                content.add(immersiveContentEntity)

                let swtch = RUISwitch() { value in
                    toggleSwitchValue = value.isOn
                }
                swtch.scale = .init(repeating: 0.1)
                swtch.position = [1, 1.25, -2]
                content.add(swtch)


            }
        }
        .addRUIDragGesture()
    }
}

#Preview(immersionStyle: .full) {
    ImmersiveView()
        .environment(AppModel())
}
