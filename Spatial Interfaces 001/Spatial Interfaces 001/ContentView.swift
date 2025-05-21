//
//  ContentView.swift
//  Spatial Interfaces 001
//
//  Created by Joseph Simpson on 5/21/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    var layoutSpacing: CGFloat = 12

    

    var body: some View {
        GeometryReader3D { proxy in
            VStack {
                Spacer()
                HStack (spacing: layoutSpacing) {
                    VStack {
                        Text("List View")
                            .font(.title)
                            .padding(.top, 12)
                        Spacer()
                    }
                    .frame(width: proxy.size.width * 0.25 - layoutSpacing)
                    .glassBackgroundEffect()

                    VStack {
                        Text("Selected Item")
                            .font(.title)
                            .padding(.top, 12)
                        Spacer()
                    }
                    .frame(width: proxy.size.width * 0.5)
                    .glassBackgroundEffect()

                    VStack {
                        Text("Inspector")
                            .font(.title)
                            .padding(.top, 12)
                        Spacer()
                    }

                    .frame(width: proxy.size.width * 0.25 - layoutSpacing)
                    .glassBackgroundEffect()
                }
                .frame(height: proxy.size.height - 50)

            }
        }
        .ornament(attachmentAnchor: .scene(.top), ornament: {
            HStack {
//                Image(systemName: "inset.filled.lefthalf.rectangle")
                Spacer()
                Text("Navigation Split View with Inspector")
                    .font(.title)
                Spacer()
//                Image(systemName: "inset.filled.righthalf.rectangle")
            }
            .frame(width: 500)
            .padding()
            .glassBackgroundEffect()

        })

    }
}

//#Preview(windowStyle: .plain) {
//    ContentView()
//}
