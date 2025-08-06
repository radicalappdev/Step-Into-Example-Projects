//
//  RenderWidget.swift
//  SimpleWidgetsExtension
//
//  Created by Joseph Simpson on 8/6/25.
//

import WidgetKit
import SwiftUI
import AppIntents

struct RenderProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> RenderEntry {
        RenderEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> RenderEntry {
        RenderEntry(date: Date(), configuration: configuration)
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<RenderEntry> {
        var entries: [RenderEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = RenderEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

    //    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
    //        // Generate a list containing the contexts this widget is relevant in.
    //    }
}

struct RenderEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct RenderWidgetsEntryView : View {
    var entry: RenderProvider.Entry
    @Environment(\.widgetRenderingMode) var renderingMode

    var body: some View {
        if renderingMode == .fullColor {
            VStack() {
                Label("WANTED", systemImage: "target")
                    .font(.headline)

                Image(.jsWidget)
                    .resizable()
                    .scaledToFit()

                Text("For taking silly photos at a metro park")
                    .font(.caption)

            }
        } else if renderingMode == .accented {
            VStack() {
                Label("WANTED", systemImage: "target")
                    .font(.headline)

                Image(.jsWidget)
                    .resizable()
                    .widgetAccentedRenderingMode(.desaturated)
                    .scaledToFit()

                Text("For taking silly photos at a metro park")
                    .font(.caption)
                    .widgetAccentable()
                    .multilineTextAlignment(.center)

            }
        }
    }


}


struct RenderWidgets: Widget {
    let kind: String = "RenderWidgets"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: RenderProvider()) { entry in
            RenderWidgetsEntryView(entry: entry)
                .containerBackground(.white.gradient, for: .widget)
        }
        .supportedFamilies([.systemExtraLargePortrait])
        .supportedMountingStyles([.elevated])
        .widgetTexture(.paper)
        .configurationDisplayName("Render Widget")
        .description("Display an image")
    }
}
