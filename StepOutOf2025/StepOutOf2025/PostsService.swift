import Foundation

struct Post: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let url: URL
    let date: Date
}

final class PostsService: NSObject {
    private let baseURL: URL

    // Keep the same initializer name to avoid touching call sites; interpret this as the site base URL.
    init(feedURL: URL) {
        // Derive origin (scheme://host[:port]/) from whatever URL was provided
        if let origin = PostsService.originURL(from: feedURL) {
            self.baseURL = origin
        } else {
            self.baseURL = feedURL
        }
    }

    func fetchPostsForYear(_ year: Int) async throws -> [Post] {
        let perPage = 100 // WordPress max per_page is 100
        var page = 1
        var collected: [Post] = []

        // Build base components for /wp-json/wp/v2/posts
        guard let endpoint = URL(string: "/wp-json/wp/v2/posts", relativeTo: baseURL) else {
            throw URLError(.badURL)
        }

        let after = "\(year)-01-01T00:00:00Z"
        let before = "\(year + 1)-01-01T00:00:00Z"

        while true {
            var components = URLComponents(url: endpoint, resolvingAgainstBaseURL: true)!
            components.queryItems = [
                URLQueryItem(name: "after", value: after),
                URLQueryItem(name: "before", value: before),
                URLQueryItem(name: "orderby", value: "date"),
                URLQueryItem(name: "order", value: "asc"),
                URLQueryItem(name: "per_page", value: String(perPage)),
                URLQueryItem(name: "page", value: String(page)),
                // Minimize payload
                URLQueryItem(name: "_fields", value: "link,date_gmt,date,title.rendered")
            ]
            guard let url = components.url else { throw URLError(.badURL) }

            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .useDefaultKeys
            let batch = try decoder.decode([WPPost].self, from: data)
            if batch.isEmpty { break }

            let mapped: [Post] = batch.compactMap { item in
                let date = PostsService.parseWPDate(gmt: item.date_gmt, local: item.date)
                guard let date = date else { return nil }
                return Post(title: item.title.rendered, url: item.link, date: date)
            }
            collected.append(contentsOf: mapped)

            if batch.count < perPage { break }
            page += 1
            if page > 1000 { break } // hard safety cap
        }

        // Extra safety: filter by year and sort
        let cal = Calendar(identifier: .gregorian)
        let filtered = collected.filter { cal.component(.year, from: $0.date) == year }
        return filtered.sorted { $0.date < $1.date }
    }

    // MARK: - Helpers

    private static func originURL(from url: URL) -> URL? {
        var comps = URLComponents()
        comps.scheme = url.scheme
        comps.host = url.host
        comps.port = url.port
        comps.path = "/"
        return comps.url
    }

    private struct WPPost: Decodable {
        let link: URL
        let date_gmt: String?
        let date: String?
        let title: Title
        struct Title: Decodable { let rendered: String }
    }

    private static func parseWPDate(gmt: String?, local: String?) -> Date? {
        // Prefer GMT; WordPress uses "YYYY-MM-DDTHH:mm:ss" (no Z) for date_gmt
        if let gmt = gmt, let d = parseGMT(gmt) { return d }
        if let local = local, let d = parseLocal(local) { return d }
        return nil
    }

    private static func parseGMT(_ s: String) -> Date? {
        // Try ISO8601 with Z first
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let d = iso.date(from: s) { return d }
        if let d = iso.date(from: s + "Z") { return d }

        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX")
        df.timeZone = TimeZone(secondsFromGMT: 0)
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return df.date(from: s)
    }

    private static func parseLocal(_ s: String) -> Date? {
        // Local time without timezone; assume system zone if needed
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX")
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let d = df.date(from: s) { return d }

        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return iso.date(from: s)
    }
}
