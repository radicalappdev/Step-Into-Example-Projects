//
//  SimpleWidgets.swift
//  SimpleWidgets
//
//  Created by Joseph Simpson on 7/27/25.
//

import WidgetKit
import SwiftUI
import AppIntents

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
                SimpleWidgetBackground(emoji: entry.configuration.emoji)
                    .position(x: -50, y: -50)
                    .opacity(0.3)

                DisplayLayout(display: entry.configuration.display, text: entry.configuration.display.rawValue)
            }
        default:
            ZStack {
                SimpleWidgetBackground(emoji: entry.configuration.emoji)
                    .position(x: -50, y: -50)
                    .opacity(0.6)

                DisplayLayout(display: entry.configuration.display, text: entry.configuration.display.rawValue)
            }
        }
    }
}

struct DisplayTitle: View {
    let text: String

    var body: some View {
            Text(text)
                .font(.system(size: 42, weight: .heavy, design: .rounded))
    }
}

struct DisplayLayout: View {
    let display: DisplayOption
    let text: String

    var body: some View {
        GeometryReader { geometry in

            switch display {
            case .live:
                VStack {
                    HStack {
                        DisplayTitle(text: text)
                        Spacer()
                    }
                    Spacer()
                }

            case .laugh:
                VStack {
                    Spacer()
                    DisplayTitle(text: text)
                    Spacer()
                }

            case .love:
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        DisplayTitle(text: text)
                    }
                }
            }
        }
    }
}

/// This will repeat an emoji in a layout larger than the parent view.
/// Use .position to adjust the starting position
struct SimpleWidgetBackground: View {
    var emoji: String

    var body: some View {
        GeometryReader { geometry in
            let emojiSize: CGFloat = 24
            let spacing: CGFloat = 4

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
            .offset(x: -patternWidth / 3, y: -patternHeight / 3)
            .clipped()
        }
    }
}

struct SimpleWidgets: Widget {
    let kind: String = "SimpleWidgets"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            SimpleWidgetsEntryView(entry: entry)
                .containerBackground(.white.gradient, for: .widget)
        }
        .supportedFamilies([.systemSmall])
        .supportedMountingStyles([.elevated, .recessed])
        .widgetTexture(.paper)
        .configurationDisplayName("Basic Widget")
        .description("Display Live, Laugh, or Love")
    }
}
