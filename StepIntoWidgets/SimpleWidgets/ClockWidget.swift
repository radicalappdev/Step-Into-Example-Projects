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

            VStack {
                ClockView()
                    .offset(z: 10)
                    .padding(.vertical, 20)
                    .manipulable()
            }
        }
    }
}

fileprivate struct ClockView: View {
    @State private var currentSecond: Int = 0
    @State private var currentHour: Int = 0
    @State private var currentMinute: Int = 0
    @State private var timer: Timer?

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Circle()
                    .fill(.stepGreen)
                RadialLayout(angleOffset: .degrees(180)) {
                    ForEach([12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], id: \.self) { hour in
                        Text("\(hour)")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.stepBackgroundPrimary)
                            .scaleEffect(min(geometry.size.width, geometry.size.height) / 400)
                    }
                }

                RadialLayout(angleOffset: .degrees(180)) {
                    ForEach(0..<60, id: \.self) { index in
                        Circle()
                            .fill(.stepBackgroundSecondary)
                            .scaleEffect(index == currentSecond ? 2.0 : 1.0)
                            .opacity(index == currentSecond ? 1.0 : 0.25)
                            .offset(z: index == currentSecond ? 5 : 0)
                            .shadow(radius: index == currentSecond ? 5 : 0, x: 0.0, y: 0.0)
                            .animation(.easeInOut(duration: 0.5), value: currentSecond)
                            .id(index)
                    }
                }
                .scaleEffect(0.74)

                ZStack {
                    // Hour hand
                    Rectangle()
                        .fill(.stepBackgroundSecondary)
                        .frame(width: 6, height: 80)
                        .offset(y: -40)
                        .offset(z: 5)
                        .rotationEffect(.degrees(Double(currentHour) * 30 + Double(currentMinute) * 0.5))
                        .shadow(radius: 1, x: 0.0, y: 0.0)
                        .scaleEffect(min(geometry.size.width, geometry.size.height) / 400)

                    // Minute hand
                    Rectangle()
                        .fill(.stepBackgroundSecondary)
                        .frame(width: 4, height: 100)
                        .offset(y: -40)
                        .offset(z: 3)
                        .rotationEffect(.degrees(Double(currentMinute) * 6))
                        .shadow(radius: 1, x: 0.0, y: 0.0)
                        .scaleEffect(min(geometry.size.width, geometry.size.height) / 400)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
    }

    private func startTimer() {
        // Update to current time immediately
        updateTime()

        // Calculate time until next second starts
        scheduleNextUpdate()
    }

    private func updateTime() {
        let calendar = Calendar.current
        let now = Date().addingTimeInterval(0.1) // Add small offset to get current time
        currentSecond = calendar.component(.second, from: now)
        currentHour = calendar.component(.hour, from: now) % 12
        currentMinute = calendar.component(.minute, from: now)
    }

    private func scheduleNextUpdate() {
        // Get the current second interval
        let now = Date()
        guard let currentSecondInterval = Calendar.current.dateInterval(of: .second, for: now) else { return }

        // Calculate time until the start of the next second
        let nextSecondStart = currentSecondInterval.end
        let timeUntilNextSecond = nextSecondStart.timeIntervalSinceNow

        // Schedule update at the exact start of the next second
        DispatchQueue.main.asyncAfter(deadline: .now() + timeUntilNextSecond) {
            // Get time immediately when this fires
            let calendar = Calendar.current
            let currentTime = Date()
            self.currentSecond = calendar.component(.second, from: currentTime)
            self.currentHour = calendar.component(.hour, from: currentTime) % 12
            self.currentMinute = calendar.component(.minute, from: currentTime)
            self.scheduleNextUpdate() // Schedule the next update
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
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
