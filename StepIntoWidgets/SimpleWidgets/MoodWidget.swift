//
//  MoodWidget.swift
//  MoodWidgetsExtension
//
//  Created by Joseph Simpson on 8/5/25.
//

import WidgetKit
import SwiftUI
import AppIntents

struct MoodProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> MoodEntry {
        MoodEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> MoodEntry {
        MoodEntry(date: Date(), configuration: configuration)
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<MoodEntry> {
        var entries: [MoodEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = MoodEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

    //    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
    //        // Generate a list containing the contexts this widget is relevant in.
    //    }
}

struct MoodEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct MoodWidgetsEntryView : View {
    var entry: MoodProvider.Entry

    var body: some View {
        VStack {
            Text("🤷🏻‍♂️")
        }
    }
}


struct MoodWidgets: Widget {
    let kind: String = "MoodWidgets"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: MoodProvider()) { entry in
            MoodWidgetsEntryView(entry: entry)
                .containerBackground(.white.gradient, for: .widget)
        }
        .supportedFamilies([.systemSmall])
        .supportedMountingStyles([.elevated, .recessed])
        .widgetTexture(.paper)
        .configurationDisplayName("Basic Widget")
        .description("Display Live, Laugh, or Love")
    }
}
