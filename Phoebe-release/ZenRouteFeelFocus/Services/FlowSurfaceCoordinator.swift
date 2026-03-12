import Foundation
import WebKit
import UIKit

final class FlowSurfaceCoordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
    
    private let viewModel: FlowSurfaceViewModel
    
    weak var refreshControl: UIRefreshControl?
    weak var primarySurface: WKWebView?
    
    private var temporarySurface: WKWebView?
    
    init(viewModel: FlowSurfaceViewModel) {
        self.viewModel = viewModel
        super.init()
        registerKeyboardNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleRefresh(_ sender: UIRefreshControl) {
        viewModel.reload()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            sender.endRefreshing()
        }
    }
    
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDidShow),
            name: UIResponder.keyboardDidShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDidHide),
            name: UIResponder.keyboardDidHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        softViewportRefresh()
    }
    
    @objc private func keyboardDidShow(_ notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.softViewportRefresh()
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        softViewportRefresh()
    }
    
    @objc private func keyboardDidHide(_ notification: Notification) {
        softViewportRefresh()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            self.softViewportRefresh()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.softViewportRefresh()
        }
    }
    
    private func softViewportRefresh() {
        guard let surface = primarySurface else { return }
        
        let script = """
        (function() {
            window.dispatchEvent(new Event('resize'));
            if (window.visualViewport) {
                window.dispatchEvent(new Event('resize'));
            }
            window.scrollBy(0, 1);
            window.scrollBy(0, -1);
        })();
        """
        
        surface.evaluateJavaScript(script, completionHandler: nil)
        
        let offset = surface.scrollView.contentOffset
        surface.scrollView.setContentOffset(
            CGPoint(x: offset.x, y: offset.y + 1),
            animated: false
        )
        surface.scrollView.setContentOffset(offset, animated: false)
    }
    
    private func handleExternalScheme(_ url: URL) -> Bool {
        guard
            let scheme = url.scheme?.lowercased(),
            scheme != "http",
            scheme != "https",
            scheme != "about"
        else {
            return false
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        return true
    }
    
    @discardableResult
    private func presentAlertController(
        message: String?,
        preferredStyle: UIAlertController.Style = .alert,
        configuration: ((UIAlertController) -> Void)? = nil
    ) -> Bool {
        let controller = UIAlertController(title: nil, message: message, preferredStyle: preferredStyle)
        configuration?(controller)
        
        guard
            let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let root = scene.windows.first(where: { $0.isKeyWindow })?.rootViewController
        else {
            return false
        }
        
        root.present(controller, animated: true)
        return true
    }
    
    private func completeRefreshIfNeeded() {
        DispatchQueue.main.async {
            self.refreshControl?.endRefreshing()
        }
    }
    
    private func captureRealURL(from surface: WKWebView) -> Bool {
        guard
            surface == temporarySurface,
            let url = surface.url
        else {
            return false
        }
        
        let absolute = url.absoluteString
        guard !absolute.isEmpty, absolute != "about:blank", !absolute.hasPrefix("about:") else {
            return false
        }
        
        primarySurface?.load(URLRequest(url: url))
        temporarySurface = nil
        return true
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        _ = captureRealURL(from: webView)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        SessionStorageManager.shared.saveCookies(from: webView)
        completeRefreshIfNeeded()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
      
        completeRefreshIfNeeded()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
      
        completeRefreshIfNeeded()
    }
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if captureRealURL(from: webView) {
            decisionHandler(.cancel)
            return
        }
        
        if
            let url = navigationAction.request.url,
            handleExternalScheme(url)
        {
            decisionHandler(.cancel)
            return
        }
        
        if navigationAction.targetFrame == nil, let url = navigationAction.request.url {
            webView.load(URLRequest(url: url))
            decisionHandler(.cancel)
            return
        }
        
        decisionHandler(.allow)
    }
    
    func webView(
        _ webView: WKWebView,
        createWebViewWith configuration: WKWebViewConfiguration,
        for navigationAction: WKNavigationAction,
        windowFeatures: WKWindowFeatures
    ) -> WKWebView? {
        if let url = navigationAction.request.url, !url.absoluteString.isEmpty, url.absoluteString != "about:blank" {
            webView.load(URLRequest(url: url))
            return nil
        }
        
        let temp = WKWebView(frame: .zero, configuration: configuration)
        temp.navigationDelegate = self
        temp.uiDelegate = self
        temp.isHidden = true
        temporarySurface = temp
        return temp
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        if webView == temporarySurface {
            temporarySurface = nil
        }
    }
    
    func webView(
        _ webView: WKWebView,
        runJavaScriptAlertPanelWithMessage message: String,
        initiatedByFrame frame: WKFrameInfo,
        completionHandler: @escaping () -> Void
    ) {
        let presented = presentAlertController(message: message) { controller in
            controller.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                completionHandler()
            })
        }
        
        if !presented {
            completionHandler()
        }
    }
    
    func webView(
        _ webView: WKWebView,
        runJavaScriptConfirmPanelWithMessage message: String,
        initiatedByFrame frame: WKFrameInfo,
        completionHandler: @escaping (Bool) -> Void
    ) {
        let presented = presentAlertController(message: message) { controller in
            controller.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
                completionHandler(false)
            })
            controller.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                completionHandler(true)
            })
        }
        
        if !presented {
            completionHandler(false)
        }
    }
    
    func webView(
        _ webView: WKWebView,
        runJavaScriptTextInputPanelWithPrompt prompt: String,
        defaultText: String?,
        initiatedByFrame frame: WKFrameInfo,
        completionHandler: @escaping (String?) -> Void
    ) {
        let presented = presentAlertController(message: prompt) { controller in
            controller.addTextField { textField in
                textField.text = defaultText
            }
            controller.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
                completionHandler(nil)
            })
            controller.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                completionHandler(controller.textFields?.first?.text)
            })
        }
        
        if !presented {
            completionHandler(nil)
        }
    }
}

