//
//  ClockWidget.swift
//  SimpleWidgetsExtension
//
//  Created by Joseph Simpson on 8/4/25.
//

import WidgetKit
import SwiftUI
import AppIntents

struct ClockProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> ClockEntry {
        let config = ClockConfigurationAppIntent()
        return ClockEntry(date: Date(), configuration: config)
    }

    func snapshot(for configuration: ClockConfigurationAppIntent, in context: Context) async -> ClockEntry {
        return ClockEntry(date: Date(), configuration: configuration)
    }

    func timeline(for configuration: ClockConfigurationAppIntent, in context: Context) async -> Timeline<ClockEntry> {
        var entries: [ClockEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = ClockEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

    func recommendations(for configuration: ClockConfigurationAppIntent, in context: Context) async -> [ClockConfigurationAppIntent] {
        return []
    }

}

struct ClockEntry: TimelineEntry {
    let date: Date
    let configuration: ClockConfigurationAppIntent
}

struct ClockWidgetEntryView: View {
    var entry: ClockProvider.Entry
    @Environment(\.levelOfDetail) var levelOfDetail: LevelOfDetail

    private var storedCount: Int {
        let count = UserDefaults.standard.integer(forKey: "ClockWidgetCount")
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
                // Radial Clock layout
                RadialLayout(angleOffset: .degrees(0)) {
                    ForEach(0..<max(1, storedCount), id: \.self) { index in
                        Text(entry.configuration.message)
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

struct ClockWidget: Widget {
    let kind: String = "ClockWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ClockConfigurationAppIntent.self, provider: ClockProvider()) { entry in
            ClockWidgetEntryView(entry: entry)
                .containerBackground(.white.gradient, for: .widget)
        }
        .supportedFamilies([.systemExtraLargePortrait])
        .supportedMountingStyles([.elevated, .recessed])
        .widgetTexture(.paper)
        .configurationDisplayName("Clock Circle")
        .description("Adjust the number of Clocks in a radial layout")
        .contentMarginsDisabled()
    }
}
