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
