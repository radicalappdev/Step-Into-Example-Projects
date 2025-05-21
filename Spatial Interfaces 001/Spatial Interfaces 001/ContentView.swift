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
    @State private var figures: [HistoricalFigure] = loadFigures()
    @State private var selectedFigure: HistoricalFigure?

    var body: some View {
        GeometryReader3D { proxy in
            VStack {
                Spacer()
                HStack (spacing: layoutSpacing) {
                    VStack(alignment: .leading) {

                        List(figures) { figure in
                            Button(action: {
                                selectedFigure = figure

                            }, label: {
                                HStack {
                                    Image(figure.imageUrl)
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                    Text(figure.name)
                                }

                            })
//                            .hoverEffect()
//                            HStack {
//                            }
//                            .onTapGesture {
//                            }
                        }
                        .padding(.top, 12)
//                        .listStyle(.plain)
                        Spacer()
                    }
                    .frame(width: proxy.size.width * 0.25 - layoutSpacing)
                    .glassBackgroundEffect()

                    VStack {
                        if let selected = selectedFigure {
                            Text(selected.name)
                                .font(.title)
                                .padding(.top, 12)
                            VStack(alignment: .leading, spacing: 8) {
                                Image(selected.imageUrl)
                                    .resizable()
                                    .frame(width: 120, height: 120)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                Text(selected.name)
                                    .font(.headline)
                                Text(selected.shortDescription)
                                    .font(.subheadline)
                                Text(selected.longDescription)
                                    .font(.body)
                                    .padding(.top, 8)
                            }
                            .padding()
                        } else {
                            Spacer()
                        }
                        Spacer()
                    }
                    .frame(width: proxy.size.width * 0.5)
                    .glassBackgroundEffect()

                    VStack {
                        Text("Inspector")
                            .font(.title)
                            .padding(.top, 12)
                        if let selected = selectedFigure {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Born: \(selected.born)")
                                Text("Died: \(selected.died)")
                                Text("Nationality: \(selected.nationality)")
                                Text("Education: \(selected.education)")
                                Text("Occupation: \(selected.occupation)")
                                Text("Known For: \(selected.knownFor)")
                                Text("Active Years: \(selected.activeYears)")
                                Text("Image Attribution: \(selected.imageAttribution)")
                            }
                            .font(.caption)
                            .padding()
                        } else {
                            Spacer()
                        }
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
                Spacer()
                Text("Navigation Split View with Inspector")
                    .font(.title)
                Spacer()
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
