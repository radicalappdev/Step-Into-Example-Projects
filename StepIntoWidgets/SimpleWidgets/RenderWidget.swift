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
        RenderEntry(date: Date(), configuration: RenderConfigurationAppIntent())
    }

    func snapshot(for configuration: RenderConfigurationAppIntent, in context: Context) async -> RenderEntry {
        RenderEntry(date: Date(), configuration: configuration)
    }

    func timeline(for configuration: RenderConfigurationAppIntent, in context: Context) async -> Timeline<RenderEntry> {
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
    let configuration: RenderConfigurationAppIntent
}

struct RenderWidgetsEntryView : View {
    var entry: RenderProvider.Entry
    @Environment(\.widgetRenderingMode) var renderingMode

    var widgetRenderingMode: WidgetAccentedRenderingMode {
        switch entry.configuration.value {
        case .accented:
            return .accented
        case .accentedDesaturated:
            return .accentedDesaturated
        case .desaturated:
            return .desaturated
        case .fullColor:
            return .fullColor
        }
    }

    var body: some View {
        if renderingMode == .fullColor {
            VStack() {
                Label("WANTED", systemImage: "target")
                    .font(.headline)
                    .foregroundStyle(.stepBackgroundSecondary)
                    .padding()

                Image(.jsWidget)
                    .resizable()
                    .scaledToFit()
                    .clipShape(.rect(cornerRadius: 12))
                    .shadow(radius: 6)

                Text("For taking silly photos at a metro park")
                    .font(.caption2)
                    .foregroundStyle(.stepBackgroundSecondary)
                    .padding()
            }
        } else if renderingMode == .accented {
            // Provide an alternative view in accented mode
            VStack() {
                Label("WANTED", systemImage: "target")
                    .font(.headline)
                    .padding()

                Image(.jsWidget)
                    .resizable()
                    .widgetAccentedRenderingMode(widgetRenderingMode)
                    .clipShape(.rect(cornerRadius: 12))
                    .scaledToFit()

                Text("For taking silly photos at a metro park")
                    .font(.caption2)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
    }
}

struct RenderWidgets: Widget {
    let kind: String = "RenderWidgets"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: RenderConfigurationAppIntent.self, provider: RenderProvider()) { entry in
            RenderWidgetsEntryView(entry: entry)
                .containerBackground(.stepGreen.gradient, for: .widget)
        }
        .supportedFamilies([.systemExtraLargePortrait])
        .supportedMountingStyles([.elevated])
        .widgetTexture(.paper)
        .configurationDisplayName("Render Widget")
        .description("Display an image")
    }
}
