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

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.stepBackgroundPrimary, .stepBackgroundSecondary],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            switch levelOfDetail {
            case .simplified:
                ClockView(showSeconds: false)
                    .offset(z: 10)
                    .padding(.vertical, 20)

            default:

                ClockView()
                    .offset(z: 10)
                    .padding(.vertical, 20)
            }
        }
    }
}

fileprivate struct ClockView: View {

    let currentTime: Date
    let showSeconds: Bool

    init(showSeconds: Bool = true) {
        self.currentTime = Date()
        self.showSeconds = showSeconds
    }
    
    private var currentSecond: Int {
        Calendar.current.component(.second, from: currentTime)
    }
    
    private var currentHour: Int {
        Calendar.current.component(.hour, from: currentTime) % 12
    }
    
    private var currentMinute: Int {
        Calendar.current.component(.minute, from: currentTime)
    }

    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            let scale = size / 200 // Base scale for a 200pt reference size

            ZStack {
                // Background circle
                Circle()
                    .fill(.stepGreen)
                    .frame(width: size , height: size )
                
                // Hour numbers
                RadialLayout(angleOffset: .degrees(180)) {
                    ForEach([12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], id: \.self) { hour in
                        Text("\(hour)")
                            .font(.system(size: 16 * scale, weight: .bold))
                            .foregroundColor(.stepBackgroundPrimary)
                    }
                }
                .frame(width: size * 0.95, height: size * 0.95)

                if(showSeconds) {
                    // Second markers
                    RadialLayout(angleOffset: .degrees(180)) {
                        ForEach(0..<60, id: \.self) { index in
                            Circle()
                                .fill(.stepBackgroundSecondary)
                                .frame(width: index == currentSecond ? 6 * scale : 3 * scale, 
                                       height: index == currentSecond ? 6 * scale : 3 * scale)
                                .opacity(index == currentSecond ? 1.0 : 0.25)
                                .offset(z: index == currentSecond ? 5 : 0)
                                .shadow(radius: index == currentSecond ? 3 : 0, x: 0.0, y: 0.0)
                                .id(index)
                        }
                    }
                    .frame(width: size * 0.66, height: size * 0.66)
                }

                // Clock hands
                ZStack {
                    // Hour hand
                    Rectangle()
                        .fill(.stepBackgroundSecondary)
                        .frame(width: 4 * scale, height: 50 * scale)
                        .offset(y: -25 * scale)
                        .offset(z: 5)
                        .rotationEffect(.degrees(Double(currentHour) * 30 + Double(currentMinute) * 0.5))
                        .shadow(radius: 1, x: 0.0, y: 0.0)

                    // Minute hand
                    Rectangle()
                        .fill(.stepBackgroundSecondary)
                        .frame(width: 3 * scale, height: 70 * scale)
                        .offset(y: -35 * scale)
                        .offset(z: 3)
                        .rotationEffect(.degrees(Double(currentMinute) * 6))
                        .shadow(radius: 1, x: 0.0, y: 0.0)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

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
        .supportedFamilies([.systemSmall])
        .supportedMountingStyles([.elevated])
        .widgetTexture(.paper)
        .configurationDisplayName("Clock Circle")
        .description("Adjust the number of Clocks in a radial layout")
        .contentMarginsDisabled()
    }
}
