//
//  SimpleWidgets.swift
//  SimpleWidgets
//
//  Created by Joseph Simpson on 7/27/25.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct SimpleWidgetsEntryView : View {
    var entry: Provider.Entry
    @Environment(\.levelOfDetail) var levelOfDetail: LevelOfDetail

    var body: some View {
        switch levelOfDetail {
        case .simplified:
            ZStack {
                EmojiBackground(emoji: entry.configuration.emoji)
                    .position(x: -50, y: -50)
                    .opacity(0.3)

                DisplyView(display: entry.configuration.display, text: entry.configuration.display.rawValue)
                                }
        default:
            ZStack {
                EmojiBackground(emoji: entry.configuration.emoji)
                    .position(x: -50, y: -50)
                    .opacity(0.6)

                DisplyView(display: entry.configuration.display, text: entry.configuration.display.rawValue)

            }
        }
    }
}

struct DisplyView: View {
    let display: DisplayOption
    let text: String

    var body: some View {
        GeometryReader { geometry in
            switch display {
            case .live:
                Text(text)
                    .font(.system(.title, design: .rounded, weight: .heavy))
                    .position(x: geometry.size.width * 0.25, y: geometry.size.height * 0.25)

            case .laugh:
                Text(text)
                    .font(.system(.title, design: .rounded, weight: .heavy))
                    .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.5)

            case .love:
                Text(text)
                    .font(.system(.title, design: .rounded, weight: .heavy))
                    .position(x: geometry.size.width * 0.75, y: geometry.size.height * 0.75)

            }
        }
    }
}

struct EmojiBackground: View {
    var emoji: String

    var body: some View {
        GeometryReader { geometry in
            let emojiSize: CGFloat = 20
            let spacing: CGFloat = 4

            // Make the pattern area much larger than the widget
            let patternWidth = geometry.size.width * 3
            let patternHeight = geometry.size.height * 3

            let rows = Int(patternHeight / (emojiSize + spacing))
            let cols = Int(patternWidth / (emojiSize + spacing))

            VStack(spacing: spacing) {
                ForEach(0..<rows, id: \.self) { row in
                    HStack(spacing: spacing) {
                        ForEach(0..<cols, id: \.self) { col in
                            Text(emoji)
                                .font(.system(size: emojiSize))
                        }
                    }
                    .offset(x: row % 2 == 0 ? 0 : emojiSize / 2 + spacing / 2)
                }
            }
            .frame(width: patternWidth, height: patternHeight)
            .offset(x: -patternWidth / 3, y: -patternHeight / 3) // Center the visible portion
            .clipped()
        }
    }
}

struct SimpleWidgets: Widget {
    let kind: String = "SimpleWidgets"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            SimpleWidgetsEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall])
        .supportedMountingStyles([.elevated, .recessed])
        .widgetTexture(.paper)
    }
}
