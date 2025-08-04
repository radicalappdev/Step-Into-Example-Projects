//
//  AppIntent.swift
//  SimpleWidgets
//
//  Created by Joseph Simpson on 7/27/25.
//

import WidgetKit
import AppIntents
import SwiftUI

// Create a custom type we can use with a picker
enum DisplayOption: String, AppEnum {
    case live = "Live"
    case laugh = "Laugh"
    case love = "Love"

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Title Options"

    static var caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .live: DisplayRepresentation(title: "Live"),
        .laugh: DisplayRepresentation(title: "Laugh"),
        .love: DisplayRepresentation(title: "Love")
    ]
}

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Configuration" }
    static var description: IntentDescription { "Choose a display option" }

    @Parameter(title: "Title", default: .live)
    var display: DisplayOption

    @Parameter(title: "Emoji", default: "🌸")
    var emoji: String
}

struct EmojiConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Emoji Configuration" }
    static var description: IntentDescription { "Choose an emoji to display" }

    @Parameter(title: "Emoji", default: "🌟")
    var emoji: String
}

struct IncrementCountIntent: AppIntent {
    static var title: LocalizedStringResource = "Increment Count"
    static var description: IntentDescription = "Increase the emoji count by 1"
    
    func perform() async throws -> some IntentResult {
        // Get current count from UserDefaults and increment
        let currentCount = UserDefaults.standard.integer(forKey: "EmojiWidgetCount")
        let newCount = min(currentCount + 1, 12)
        UserDefaults.standard.set(newCount, forKey: "EmojiWidgetCount")
        
        // Reload the widget timeline
        WidgetCenter.shared.reloadTimelines(ofKind: "EmojiWidget")
        
        return .result()
    }
}

struct DecrementCountIntent: AppIntent {
    static var title: LocalizedStringResource = "Decrement Count"
    static var description: IntentDescription = "Decrease the emoji count by 1"
    
    func perform() async throws -> some IntentResult {
        // Get current count from UserDefaults and decrement
        let currentCount = UserDefaults.standard.integer(forKey: "EmojiWidgetCount")
        let newCount = max(currentCount - 1, 1)
        UserDefaults.standard.set(newCount, forKey: "EmojiWidgetCount")
        
        // Reload the widget timeline
        WidgetCenter.shared.reloadTimelines(ofKind: "EmojiWidget")
        
        return .result()
    }
}

struct ClockConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Clock Face Message" }
    static var description: IntentDescription { "Enter a short message to display on the clock face" }

    @Parameter(title: "Message", default: "🌟")
    var message: String
}
