import SwiftUI
import Observation

@MainActor
@Observable
final class FiveHundredPostsSlideshowViewModel {
    var posts: [Post] = []
    var currentIndex: Int = 0
    var isLoading: Bool = true

    private let service: PostsService
    private let postCount: Int
    private var timer: Timer?

    init(feedURL: URL, postCount: Int = 500) {
        self.service = PostsService(feedURL: feedURL)
        self.postCount = postCount
    }

    func load() async {
        do {
            let latestPosts = try await service.fetchLatestPosts(limit: postCount)
            self.posts = latestPosts
            self.currentIndex = 0
            self.isLoading = false
        } catch {
            print("Failed to load latest posts: \(error)")
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

struct FiveHundredPostsSlideshowView: View {
    let feedURL: URL
    var displayDuration: TimeInterval = 2.0

    @State private var model: FiveHundredPostsSlideshowViewModel
    @State private var isAutoPlaying: Bool = false

    init(feedURL: URL, displayDuration: TimeInterval = 2.0) {
        self.feedURL = feedURL
        self.displayDuration = displayDuration
        _model = State(wrappedValue: FiveHundredPostsSlideshowViewModel(feedURL: feedURL))
    }

    var body: some View {
        ZStack {
            if model.isLoading {
                ProgressView("Loading 500 posts...")
            } else if model.posts.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "doc.text")
                        .font(.largeTitle)
                    Text("No posts found")
                        .foregroundStyle(.secondary)
                }
                .padding()
            } else if let url = currentPost?.url {
                WebView(url: url)
                    .clipShape(.rect(cornerRadius: 24))
                    .padding()
            } else {
                Color.clear
            }
        }
        .ornament(attachmentAnchor: .scene(.top), ornament: {
            VStack(spacing: 4) {
                Text("🎉 500 posts on Step Vision 🎉")
                    .font(.title)
            }
            .padding()
            .glassBackgroundEffect()
        })
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
            await model.load()
        }
        .onDisappear {
            model.stopCycling()
            isAutoPlaying = false
        }
        .animation(.default, value: model.currentIndex)
    }

    private var currentPost: Post? {
        guard model.posts.indices.contains(model.currentIndex) else { return nil }
        return model.posts[model.currentIndex]
    }

    private var progressText: String {
        guard !model.posts.isEmpty else { return "" }
        return "\(model.currentIndex + 1) of \(model.posts.count)"
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
    FiveHundredPostsSlideshowView(feedURL: URL(string: "https://stepinto.vision/")!, displayDuration: 2.0)
}
