import SwiftUI
import WebKit
import Observation

@MainActor
@Observable
final class PostsSlideshowViewModel {
    var posts: [Post] = []
    var currentIndex: Int = 0
    var isLoading: Bool = true

    private let service: PostsService
    private var timer: Timer?

    init(feedURL: URL) {
        self.service = PostsService(feedURL: feedURL)
    }

    func load() async {
        do {
            let posts2025 = try await service.fetchPostsForYear(2025)
            self.posts = posts2025
            self.currentIndex = 0
            self.isLoading = false
        } catch {
            print("Failed to load posts: \(error)")
            self.posts = []
            self.isLoading = false
        }
    }

    func startCycling(every seconds: TimeInterval) {
        stopCycling()
        guard !posts.isEmpty else { return }
        timer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: true) { [weak self] _ in
            guard let self else { return }
            Task { @MainActor in
                guard !self.posts.isEmpty else { return }
                self.currentIndex = (self.currentIndex + 1) % self.posts.count
            }
        }
    }

    func stopCycling() {
        timer?.invalidate()
        timer = nil
    }
}

struct PostsSlideshowView: View {
    let feedURL: URL
    var displayDuration: TimeInterval = 2.0

    @State private var model: PostsSlideshowViewModel
    @State private var firstLoadFinished = false
    @State private var isAutoPlaying: Bool = false

    init(feedURL: URL, displayDuration: TimeInterval = 2.0) {
        self.feedURL = feedURL
        self.displayDuration = displayDuration
        _model = State(wrappedValue: PostsSlideshowViewModel(feedURL: feedURL))
    }

    var body: some View {
        ZStack {
            if model.isLoading {
                AnyView(ProgressView("Loading posts…"))
            } else if model.posts.isEmpty {
                AnyView(
                    VStack(spacing: 8) {
                        Image(systemName: "doc.text")
                            .font(.largeTitle)
                        Text("No posts found")
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                )
            } else {
                AnyView(
                    Group {
                        if let url = (model.posts.indices.contains(model.currentIndex) ? model.posts[model.currentIndex].url : nil) {
                            WebView(url: url)
                                .clipShape(.rect(cornerRadius: 24))
                                .padding()
                        } else {
                            Color.clear
                        }
                    }
                )
            }
        }
//        .ornament(attachmentAnchor: .scene(.top), ornament: {
//            Text("Step Into Vision")
//                .font(.title)
//                .padding()
//                .glassBackgroundEffect()
//        })
        .ornament(attachmentAnchor: .scene(.bottom), ornament: {
            HStack(spacing: 8) {
                Button(action: previous) {
                    Image(systemName: "chevron.left").font(.title2)
                }
                Button(action: togglePlay) {
                    Image(systemName: isAutoPlaying ? "pause.fill" : "play.fill").font(.title2)
                }
                Button(action: next) {
                    Image(systemName: "chevron.right").font(.title2)
                }
            }
            .padding()
            .glassBackgroundEffect()
        })
        .task {
            // Initial load of posts; user presses Play to start cycling
            await model.load()
            firstLoadFinished = true
        }
        .onDisappear {
            model.stopCycling()
            isAutoPlaying = false
        }
        .animation(.default, value: model.currentIndex)
    }

    private func togglePlay() {
        if isAutoPlaying {
            isAutoPlaying = false
            model.stopCycling()
        } else {
            guard !model.isLoading, !model.posts.isEmpty else { return }
            isAutoPlaying = true
            model.startCycling(every: displayDuration)
        }
    }

    private func next() {
        guard !model.posts.isEmpty else { return }
        model.currentIndex = (model.currentIndex + 1) % model.posts.count
    }

    private func previous() {
        guard !model.posts.isEmpty else { return }
        model.currentIndex = (model.currentIndex - 1 + model.posts.count) % model.posts.count
    }
}

#Preview {
    PostsSlideshowView(feedURL: URL(string: "https://example.com/feed.xml")!, displayDuration: 2.0)
}

