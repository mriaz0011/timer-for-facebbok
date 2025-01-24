import WebKit

protocol WebContentViewDelegate: AnyObject {
    func webContentViewDidStartLoading()
    func webContentViewDidFinishLoading()
    func webContentViewDidFailLoading(with error: Error)
    func webContentViewCanGoBack() -> Bool
}

class WebContentView: UIView {
    private let webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = .white
        webView.isOpaque = true
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    var canGoBack: Bool {
        return webView.canGoBack
    }
    
    weak var delegate: WebContentViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        
        addSubview(webView)
        addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        webView.navigationDelegate = self
    }
    
    func load(_ content: WebContent) {
        loadingIndicator.startAnimating()
        
        switch content.type {
        case .url:
            if let url = URL(string: content.content) {
                webView.load(URLRequest(url: url))
            }
        case .html:
            webView.loadHTMLString(content.content, baseURL: nil)
        }
    }
    
    func load(_ request: URLRequest) {
        loadingIndicator.startAnimating()
        webView.load(request)
    }
    
    func reload() {
        webView.reload()
    }
    
    func goBack() {
        if webView.canGoBack {
            webView.goBack()
        }
    }
}

extension WebContentView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        delegate?.webContentViewDidStartLoading()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingIndicator.stopAnimating()
        delegate?.webContentViewDidFinishLoading()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        loadingIndicator.stopAnimating()
        delegate?.webContentViewDidFailLoading(with: error)
    }
} 
