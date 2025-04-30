import SwiftUI
import WebKit

struct SpotifyLoginView: UIViewRepresentable {
    let authURL: URL
    let onCodeExtracted: (String) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onCodeExtracted: onCodeExtracted)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.load(URLRequest(url: authURL))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    class Coordinator: NSObject, WKNavigationDelegate {
        let onCodeExtracted: (String) -> Void

        init(onCodeExtracted: @escaping (String) -> Void) {
            self.onCodeExtracted = onCodeExtracted
        }

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)
        {
            if let url = navigationAction.request.url,
               url.absoluteString.contains("code="),
               let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
               let code = components.queryItems?.first(where: { $0.name == "code" })?.value
            {
                onCodeExtracted(code)
                decisionHandler(.cancel)
                return
            }
            decisionHandler(.allow)
        }
    }
}
