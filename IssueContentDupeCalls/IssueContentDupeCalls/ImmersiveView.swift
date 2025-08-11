//
//  ImmersiveView.swift
//  IssueContentDupeCalls
//
//  Created by Joseph Simpson on 8/11/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {

    @State var launchEntity = Entity()

    var body: some View {
        RealityView { content in

            launchEntity = createLaunchEntity() //This entity maybe creat two or more
            content.add(launchEntity)
        }
    }

    func createLaunchEntity() -> Entity {
        //...
        let entity: Entity = Entity()
        entity.name = "Launch Entity"

        let launchviewComponent = ViewAttachmentComponent(
            rootView: LaunchView()
        )
        entity.components.set(launchviewComponent) // Create a UI View to show
        //...

        print("Has Creat Test!") // It has been output once.
        return entity
    }
}

struct LaunchView: View {

    var body: some View {
        VStack {

            Text("Launch View")

        }
        .padding()
        .onAppear() {
            print("Launch view appears!")
        }
    }
}

#Preview(immersionStyle: .full) {
    ImmersiveView()
        .environment(AppModel())
}
