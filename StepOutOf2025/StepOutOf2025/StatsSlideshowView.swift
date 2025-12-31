import SwiftUI
import Combine

struct StatsSlideshowView: View {
    struct Slide: Identifiable, Equatable {
        let id = UUID()
        let title: String
        let subtitle: String?
    }

    // Slides based on the user's provided 2025 recap
    private let slides: [Slide] = [
        .init(title: "Step Into Vision", subtitle: "2025 Recap"),
        .init(title: "372", subtitle: "Total Items Published"),
        .init(title: "178.8K", subtitle: "words written"),
        .init(title: "139", subtitle: "New Examples"),
        .init(title: "81", subtitle: "New Labs"),
        .init(title: "77", subtitle: "Newsletters and Articles"),
        .init(title: "52", subtitle: "Resources"),
        .init(title: "26", subtitle: "Project Devlogs"),
        .init(title: "9", subtitle: "Guest Contributions")
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
                        Text(slide.title)
                            .font(index == 0 ? .largeTitle.bold() : .system(size: 72, weight: .bold))
                            .multilineTextAlignment(.center)
                            .minimumScaleFactor(0.5)
                            .lineLimit(2)
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

#Preview("Stats Slideshow") {
    StatsSlideshowView()
        .padding()
}
