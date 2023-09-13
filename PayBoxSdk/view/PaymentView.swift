
import WebKit
open class PaymentView: UIView, WKNavigationDelegate {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initWebView()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initWebView()
    }
    
    public var delegate: WebDelegate? = nil
    private var webView: WKWebView!
    private var sOf: ((Bool) -> Void)? = nil
    private var isFrame = true
    
    private func initWebView(){
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        webView.configuration.preferences.javaScriptEnabled = true
        webView.navigationDelegate = self
        super.addSubview(webView)
        webView.contentMode = .scaleAspectFit
    }
    
    func loadPaymentPage(url: String, sucessOrFailure: @escaping (Bool) -> Void) {
        if (url.starts(with: Urls.getBaseUrl()) || url.starts(with: Urls.getCustomerUrl())) {
            loadUrl(urlStr: url)
            self.sOf = sucessOrFailure
            self.isFrame = !url.contains("pay.html")
        }
    }
    
    private func loadUrl(urlStr: String) {
        if let url = URL(string: urlStr) {
            self.webView.load(URLRequest(url: url))
        }
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if (navigationAction.navigationType == .linkActivated){
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
        if let url = navigationAction.request.url?.absoluteString {
            if url.starts(with: Urls.successUrl()) {
                if(!isFrame) {
                    self.isHidden = true
                }
                
                self.sOf?(true)
                webView.loadHTMLString("", baseURL: nil)
            } else if url.starts(with: Urls.failureUrl()) {
                if(!isFrame) {
                    self.isHidden = true
                }
                
                self.sOf?(false)
                webView.loadHTMLString("", baseURL: nil)
            }
        }
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.delegate?.loadFinished()
    }
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.delegate?.loadStarted()
    }
    
    open override func layoutSubviews() {
        return
    }
    
    open override func addSubview(_ view: UIView) {
        return
    }
    
    open override func insertSubview(_ view: UIView, at index: Int) {
        return
    }
    
    open override func sendSubviewToBack(_ view: UIView) {
        return
    }
    
    open override func exchangeSubview(at index1: Int, withSubviewAt index2: Int) {
        return
    }
    
    open override func insertSubview(_ view: UIView, aboveSubview siblingSubview: UIView) {
        return
    }
    
    open override func insertSubview(_ view: UIView, belowSubview siblingSubview: UIView) {
        return
    }
    
    open override func didAddSubview(_ subview: UIView) {
        return
    }
    
    open override func willRemoveSubview(_ subview: UIView) {
        return
    }
    
    open override func bringSubviewToFront(_ view: UIView) {
        return
    }
}

public protocol WebDelegate {
    
    func loadStarted()
    func loadFinished()
}
