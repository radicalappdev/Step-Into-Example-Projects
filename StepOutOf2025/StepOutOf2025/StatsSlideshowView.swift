import SwiftUI
import Combine

struct StatsSlideshowView: View {
    struct Slide: Identifiable, Equatable {
        let id = UUID()
        let title: String
        let subtitle: String?
        let numericTarget: Double?
    }

    // Slides based on the user's provided 2025 recap
    private let slides: [Slide] = [
        .init(title: "Step Into Vision", subtitle: "2025 Recap", numericTarget: nil),
        .init(title: "372", subtitle: "Total Items Published", numericTarget: 372),
        .init(title: "178.8K", subtitle: "words written", numericTarget: 178800),
        .init(title: "139", subtitle: "New Examples", numericTarget: 139),
        .init(title: "81", subtitle: "New Labs", numericTarget: 81),
        .init(title: "77", subtitle: "Newsletters and Articles", numericTarget: 77),
        .init(title: "52", subtitle: "Resources", numericTarget: 52),
        .init(title: "26", subtitle: "Project Devlogs", numericTarget: 26),
        .init(title: "9", subtitle: "Guest Contributions", numericTarget: 9)
    ]

    @State private var currentIndex: Int = 0
    @State private var isAutoPlaying: Bool = true

    // Auto-advance every 3 seconds
    private let timer = Timer.publish(every: 3.0, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 16) {
            TabView(selection: $currentIndex) {
                ForEach(Array(slides.enumerated()), id: \.offset) { index, slide in
                    VStack(spacing: 12) {
                        if index == 0 || slide.numericTarget == nil {
                            Text(slide.title)
                                .font(index == 0 ? .largeTitle.bold() : .system(size: 72, weight: .bold))
                                .multilineTextAlignment(.center)
                                .minimumScaleFactor(0.5)
                                .lineLimit(2)
                        } else {
                            // Animate only when this slide is visible
                            CountUpText(target: slide.numericTarget ?? 0, duration: 0.9, font: .system(size: 72, weight: .bold))
                                .id(currentIndex == index) // restart when slide becomes active
                        }
                        if let subtitle = slide.subtitle {
                            Text(subtitle)
                                .font(.title2)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                    .tag(index)
                }
            }
            .id(currentIndex)
            .tabViewStyle(.page(indexDisplayMode: .automatic))
            .onReceive(timer) { _ in
                guard isAutoPlaying else { return }
                withAnimation(.easeInOut) {
                    currentIndex = (currentIndex + 1) % slides.count
                }
            }
            .onChange(of: currentIndex) { _, _ in
                // Pause autoplay briefly on manual swipe; simple approach: stop until play toggled again
                // Keep behavior simple for now.
            }


        }
        .frame(minHeight: 300)
        .ornament(attachmentAnchor: .scene(.top), ornament: {
            Text("Step Into Vision")
                .font(.title)
                .padding()
                .glassBackgroundEffect()
        })
        .ornament(attachmentAnchor: .scene(.bottom), ornament: {
            // Simple controls
            HStack(spacing: 4) {
                Button(action: previous) {
                    Label("Previous", systemImage: "chevron.left")
                }


                Button(action: { isAutoPlaying.toggle() }) {
                    Label(isAutoPlaying ? "Pause" : "Play", systemImage: isAutoPlaying ? "pause.fill" : "play.fill")
                }


                Button(action: next) {
                    Label("Next", systemImage: "chevron.right")
                }
            }
            .padding()
            .glassBackgroundEffect()
        })
    }

    private func next() {
        withAnimation(.easeInOut) {
            currentIndex = (currentIndex + 1) % slides.count
        }
    }

    private func previous() {
        withAnimation(.easeInOut) {
            currentIndex = (currentIndex - 1 + slides.count) % slides.count
        }
    }
}

private struct CountUpText: View {
    let target: Double
    let duration: Double
    let font: Font

    @State private var value: Double = 0
    @State private var startDate: Date = .init()
    @State private var timerCancellable: AnyCancellable?

    var body: some View {
        Text(formatted(value))
            .font(font)
            .monospacedDigit()
            .onAppear { start() }
            .onDisappear { stop() }
    }

    private func start() {
        stop()
        value = 0
        startDate = Date()
        let fps: Double = 60
        timerCancellable = Timer.publish(every: 1.0 / fps, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                let elapsed = Date().timeIntervalSince(startDate)
                let progress = min(1.0, elapsed / max(0.001, duration))
                // Ease-out curve
                let eased = 1 - pow(1 - progress, 3)
                value = target * eased
                if progress >= 1.0 {
                    stop()
                }
            }
    }

    private func stop() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }

    private func formatted(_ number: Double) -> String {
        // If target is large like 178800, keep the "K" look once close to done
        if target >= 1000 {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 1
            if target >= 1000 {
                let display = number / 1000.0
                if let str = formatter.string(from: NSNumber(value: display)) {
                    return "\(str)K"
                }
            }
        }
        let intValue = Int(number.rounded())
        return "\(intValue)"
    }
}

#Preview("Stats Slideshow") {
    StatsSlideshowView()
        .padding()
}
