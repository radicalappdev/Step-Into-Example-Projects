//
//  ContentView.swift
//  StepIntoWidgets
//
//  Created by Joseph Simpson on 7/27/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @State private var currentEmoji: String = ""

    var body: some View {
        VStack {
            Text("\(currentEmoji)")
                .font(.extraLargeTitle2)
                .padding(.bottom)
            
            HStack(spacing: 20) {
                Button(action: {
                    saveEmojiToUserDefaults("🚀")
                }) {
                    Text("🚀")
                }
                
                Button(action: {
                    saveEmojiToUserDefaults("🌸")
                }) {
                    Text("🌸")
                }
                
                Button(action: {
                    saveEmojiToUserDefaults("🐸")
                }) {
                    Text("🐸")
                }
            }
            .controlSize(.extraLarge)
        }
        .padding()
        .onAppear {
            loadCurrentEmoji()
        }
    }
    
    private func saveEmojiToUserDefaults(_ emoji: String) {
        UserDefaults.standard.set(emoji, forKey: "dataEmojiExample")
        print("Saved emoji: \(emoji) to UserDefaults")
        currentEmoji = emoji
    }
    
    private func loadCurrentEmoji() {
        if let savedEmoji = UserDefaults.standard.string(forKey: "dataEmojiExample") {
            currentEmoji = savedEmoji
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
