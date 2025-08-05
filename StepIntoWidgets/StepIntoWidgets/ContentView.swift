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
                    saveEmojiToUserDefaults("☹️")
                }) {
                    Text("☹️")
                }
                
                Button(action: {
                    saveEmojiToUserDefaults("😊")
                }) {
                    Text("😊")
                }
                
                Button(action: {
                    saveEmojiToUserDefaults("🤪")
                }) {
                    Text("🤪")
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
        sharedUserDefaults.set(emoji, forKey: "dataEmojiExample")
        print("Saved emoji: \(emoji) to shared UserDefaults")
        currentEmoji = emoji
    }
    
    private func loadCurrentEmoji() {
        if let savedEmoji = sharedUserDefaults.string(forKey: "dataEmojiExample") {
            currentEmoji = savedEmoji
        }
    }
    
    private var sharedUserDefaults: UserDefaults {
        return UserDefaults(suiteName: "group.com.radicalappdev.StepIntoWidgets") ?? UserDefaults.standard
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
