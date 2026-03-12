import SwiftUI
import WebKit
import UIKit

struct FlowSurfaceRepresentable: UIViewRepresentable {
    
    @ObservedObject var viewModel: FlowSurfaceViewModel
    let url: URL
    let useLightTheme: Bool
    
    func makeCoordinator() -> FlowSurfaceCoordinator {
        FlowSurfaceCoordinator(viewModel: viewModel)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = configureSurface()
        let surface = WKWebView(frame: .zero, configuration: configuration)
        
        surface.navigationDelegate = context.coordinator
        surface.uiDelegate = context.coordinator
        surface.allowsBackForwardNavigationGestures = true
        surface.allowsLinkPreview = false
        surface.scrollView.keyboardDismissMode = .interactive
        
        applyAppearance(to: surface)
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = useLightTheme ? .darkGray : .lightGray
        refreshControl.addTarget(context.coordinator, action: #selector(FlowSurfaceCoordinator.handleRefresh(_:)), for: .valueChanged)
        surface.scrollView.refreshControl = refreshControl
        
        context.coordinator.refreshControl = refreshControl
        context.coordinator.primarySurface = surface
        
        viewModel.configure(with: surface)
        
        SessionStorageManager.shared.loadCookies(into: surface) {
            let request = URLRequest(url: url)
            surface.load(request)
        }
        
        return surface
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
    
    private func configureSurface() -> WKWebViewConfiguration {
        let configuration = WKWebViewConfiguration()
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        configuration.defaultWebpagePreferences = preferences
        configuration.preferences.javaScriptEnabled = true
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        configuration.allowsAirPlayForMediaPlayback = true
        configuration.allowsPictureInPictureMediaPlayback = true
        
        configuration.websiteDataStore = .default()
        
        return configuration
    }
    
    private func applyAppearance(to surface: WKWebView) {
        let themeColor = useLightTheme ? UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0) : UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        surface.backgroundColor = themeColor
        surface.scrollView.backgroundColor = themeColor
        surface.isOpaque = useLightTheme
        surface.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 18_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.0 Mobile/15E148 Safari/604.1"
    }
}

