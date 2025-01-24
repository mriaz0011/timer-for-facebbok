import WebKit

protocol WebViewManagerDelegate: AnyObject {
    func webViewManager(_ manager: WebViewManager, didFailWithError error: Error)
    func webViewManagerDidFinishLoading(_ manager: WebViewManager)
}

class WebViewManager: NSObject {
    private let webView: WKWebView
    private weak var delegate: WebViewManagerDelegate?
    
    init(webView: WKWebView, delegate: WebViewManagerDelegate?) {
        self.webView = webView
        self.delegate = delegate
        super.init()
        setupWebView()
    }
    
    private func setupWebView() {
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.configuration.preferences.javaScriptEnabled = true
    }
    
    func loadURL(_ url: URL) {
        webView.load(URLRequest(url: url))
    }
    
    func loadHTMLString(_ html: String) {
        webView.loadHTMLString(html, baseURL: nil)
    }
    
    func refresh() {
        webView.reload()
    }
    
    func goBack() -> Bool {
        guard webView.canGoBack else { return false }
        webView.goBack()
        return true
    }
}

extension WebViewManager: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        delegate?.webViewManagerDidFinishLoading(self)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        delegate?.webViewManager(self, didFailWithError: error)
    }
} 