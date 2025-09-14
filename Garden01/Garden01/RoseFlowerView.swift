//
//  RoswFlowerWindow.swift
//  Garden01
//
//  Created by Joseph Simpson on 9/14/25.
//

import SwiftUI

struct RoseFlowerView: View {

    @Environment(\.dismissWindow) var dismissWindow

    var body: some View {
        VStack(spacing: 24) {

            Text("🌹 Rose Flower 🌹")
                .font(.extraLargeTitle2)

            Text("A unique window with an id value of `RoseWindow`")

            Button(action: {
                dismissWindow(id: "RoseWindow")
            }, label: {
                Label("Close Window", systemImage: "xmark.circle")
            })

        }
        .padding()
    }
}

#Preview {
    RoseFlowerView()
}
