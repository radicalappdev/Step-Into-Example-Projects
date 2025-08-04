//
//  EmojiWidget.swift
//  SimpleWidgetsExtension
//
//  Created by Joseph Simpson on 8/4/25.
//

import WidgetKit
import SwiftUI
import AppIntents

struct EmojiProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> EmojiEntry {
        let config = EmojiConfigurationAppIntent()
        return EmojiEntry(date: Date(), configuration: config)
    }

    func snapshot(for configuration: EmojiConfigurationAppIntent, in context: Context) async -> EmojiEntry {
        return EmojiEntry(date: Date(), configuration: configuration)
    }

    func timeline(for configuration: EmojiConfigurationAppIntent, in context: Context) async -> Timeline<EmojiEntry> {
        var entries: [EmojiEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = EmojiEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

    func recommendations(for configuration: EmojiConfigurationAppIntent, in context: Context) async -> [EmojiConfigurationAppIntent] {
        return []
    }

}

struct EmojiEntry: TimelineEntry {
    let date: Date
    let configuration: EmojiConfigurationAppIntent
}

struct EmojiWidgetEntryView: View {
    var entry: EmojiProvider.Entry
    @Environment(\.levelOfDetail) var levelOfDetail: LevelOfDetail

    private var storedCount: Int {
        let count = UserDefaults.standard.integer(forKey: "EmojiWidgetCount")
        return count > 0 ? count : 3 // Default to 3 if no count stored
    }

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [.blue.opacity(0.3), .purple.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            VStack {
                // Radial emoji layout
                RadialLayout(angleOffset: .degrees(0)) {
                    ForEach(0..<max(1, storedCount), id: \.self) { index in
                        Text(entry.configuration.emoji)
                            .font(.system(size: levelOfDetail == .simplified ? 30 : 40, weight: .medium))
                            .shadow(color: .black.opacity(0.2), radius: 2, x: 1, y: 1)
                    }
                }
                .padding()
                Spacer()
            }

            // Interactive buttons
            VStack {
                Spacer()
                HStack(spacing: 12) {
                    Button(intent: DecrementCountIntent()) {
                        Image(systemName: "minus.circle.fill")
                            .font(.extraLargeTitle2)
                            .padding(8)
                            .foregroundColor(.white)
                            .background(Circle().fill(Color.black.opacity(0.3)))
                    }
                    .buttonStyle(.plain)

                    Button(intent: IncrementCountIntent()) {
                        Image(systemName: "plus.circle.fill")
                            .font(.extraLargeTitle2)
                            .padding(8)
                            .foregroundColor(.white)
                            .background(Circle().fill(Color.black.opacity(0.3)))
                    }
                    .buttonStyle(.plain)
                }
                .padding()
            }
        }
    }
}

struct EmojiWidget: Widget {
    let kind: String = "EmojiWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: EmojiConfigurationAppIntent.self, provider: EmojiProvider()) { entry in
            EmojiWidgetEntryView(entry: entry)
                .containerBackground(.white.gradient, for: .widget)
        }
        .supportedFamilies([.systemExtraLargePortrait])
        .supportedMountingStyles([.elevated, .recessed])
        .widgetTexture(.paper)
        .configurationDisplayName("Emoji Circle")
        .description("Adjust the number of emojis in a radial layout")
        .contentMarginsDisabled()
    }
}
