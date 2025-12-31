import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    var onFinish: (() -> Void)? = nil

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView(frame: .zero)
        webView.navigationDelegate = context.coordinator
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        // Reload only if the URL changed to avoid flicker
        if webView.url != url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(onFinish: onFinish)
    }

    final class Coordinator: NSObject, WKNavigationDelegate {
        private let onFinish: (() -> Void)?

        init(onFinish: (() -> Void)?) {
            self.onFinish = onFinish
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            onFinish?()
        }
    }
}
