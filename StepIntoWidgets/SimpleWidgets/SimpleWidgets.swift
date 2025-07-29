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

                DisplayLayout(display: entry.configuration.display, text: entry.configuration.display.rawValue)
            }
        default:
            ZStack {
                EmojiBackground(emoji: entry.configuration.emoji)
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
struct EmojiBackground: View {
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
    }
}

// MARK: - Emoji Widget

struct EmojiProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> EmojiEntry {
        EmojiEntry(date: Date(), configuration: EmojiConfigurationAppIntent())
    }

    func snapshot(for configuration: EmojiConfigurationAppIntent, in context: Context) async -> EmojiEntry {
        EmojiEntry(date: Date(), configuration: configuration)
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
}

struct EmojiEntry: TimelineEntry {
    let date: Date
    let configuration: EmojiConfigurationAppIntent
}

struct EmojiWidgetEntryView: View {
    var entry: EmojiProvider.Entry
    @Environment(\.levelOfDetail) var levelOfDetail: LevelOfDetail

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [.blue.opacity(0.3), .purple.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Emoji display
            Text(entry.configuration.emoji)
                .font(.system(size: levelOfDetail == .simplified ? 60 : 80, weight: .medium))
                .shadow(color: .black.opacity(0.2), radius: 2, x: 1, y: 1)
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
        .supportedFamilies([.systemSmall])
        .supportedMountingStyles([.elevated, .recessed])
        .widgetTexture(.paper)
    }
}

// Taken from Canyon Crosser from WWDC 2025
// For information on custom layouts, watch https://developer.apple.com/videos/play/wwdc2022/10056.
fileprivate struct RadialLayout: Layout, Animatable {
    var angleOffset: Angle = .zero

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let updatedProposal = proposal.replacingUnspecifiedDimensions()
        let minDim = min(updatedProposal.width, updatedProposal.height)
        return CGSize(width: minDim, height: minDim)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        guard subviews.count > 1 else {
            subviews[0].place(
                at: .init(x: bounds.midX, y: bounds.midY),
                anchor: .center,
                proposal: proposal)
            return
        }
        let minDimension = min(bounds.width, bounds.height)
        let subViewDim = minDimension / CGFloat((subviews.count / 2) + 1)
        let radius = min(bounds.width, bounds.height) / 2
        let placementRadius = radius - (subViewDim / 2)
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let angleIncrement = 2 * .pi / CGFloat(subviews.count)
        let centerOffset = Double.pi / 2 // Centers the view.

        for (index, subview) in subviews.enumerated() {
            let angle = angleIncrement * CGFloat(index) + angleOffset.radians + centerOffset

            let xPosition = center.x + (placementRadius * cos(angle))
            let yPosition = center.y + (placementRadius * sin(angle))

            let point = CGPoint(x: xPosition, y: yPosition)
            subview.place(
                at: point, anchor: .center,
                proposal: .init(width: subViewDim, height: subViewDim))
        }
    }

    var animatableData: Angle.AnimatableData {
        get { angleOffset.animatableData }
        set { angleOffset.animatableData = newValue }
    }
}
