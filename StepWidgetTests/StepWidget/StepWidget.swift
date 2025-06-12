//
//  StepWidget.swift
//  StepWidget
//
//  Created by Joseph Simpson on 6/12/25.
//

import WidgetKit
import SwiftUI
import RealityKit


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

struct StepWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.levelOfDetail) var levelOfDetail: LevelOfDetail

    var body: some View {
        switch levelOfDetail {
        case .simplified:
            VStack {
                Text(entry.date, style: .time)
                    .font(.title)
                Text("Looming Deadline")
                    .font(.caption)
            }
            .foregroundStyle(.white)
        default:
            VStack(alignment: .center ) {

                Text(entry.date.addingTimeInterval(83267), style: .timer)
//                Text(formatCountdown(to: entry.date.addingTimeInterval(144267)))

                    .font(.title)
                    .multilineTextAlignment(.center) // Bypass bugs in widgets
                    .monospaced()
                    .contentTransition(.numericText(countsDown: true))

                Text("Looming Deadline")
                    .font(.caption)
            }
            .foregroundStyle(.white)
        }
    }

    func formatCountdown(to targetDate: Date) -> String {
        let interval = max(Int(targetDate.timeIntervalSinceNow), 0)
        let days = interval / 86400
        let hours = (interval % 86400) / 3600
        let minutes = (interval % 3600) / 60
        let seconds = interval % 60

        if days > 0 {
            return String(format: "%dD %02d:%02d:%02d", days, hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
    }
}

var durationFormatter: DateComponentsFormatter = {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.year, .month, .weekOfMonth, .day, .hour, .minute, .second]
    formatter.unitsStyle = .positional
    formatter.zeroFormattingBehavior = .default
    return formatter
}()

struct StepWidget: Widget {
    let kind: String = "StepWidget"

    let colorTint: Color = .red
    let colorMix: Color = .black

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            StepWidgetEntryView(entry: entry)
                .containerBackground(MeshGradient(
                    width: 3, height: 3,
                    points: [
                        .init(0, 0), .init(0.5, 0), .init(1, 0),
                        .init(0, 0.5), .init(0.5, 0.5), .init(1, 0.5),
                        .init(0, 1), .init(0.5, 1), .init(1, 1),
                    ],
                    colors: [
                        colorTint,
                        colorMix.mix(with: colorTint, by: 0.25),
                        colorTint,
                        colorMix.mix(with: colorTint, by: -0.25),
                        colorTint,
                        colorMix.mix(with: colorTint, by: 0.6),
                        colorTint,
                        colorMix.mix(with: colorTint, by: 0.3),
                        colorTint,
                    ]
                ), for: .widget)
        }
        .supportedFamilies([.systemMedium])
        .supportedMountingStyles([.elevated])
        .widgetTexture(.paper)
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}
