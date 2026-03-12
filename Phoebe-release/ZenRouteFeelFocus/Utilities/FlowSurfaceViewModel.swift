import Foundation
import Combine
import WebKit

final class FlowSurfaceViewModel: ObservableObject {
    
    @Published private(set) var canGoBack = false
    @Published private(set) var canGoForward = false
    @Published private(set) var isLoading = false
    @Published private(set) var estimatedProgress: Double = 0.0
    @Published private(set) var currentURL: URL?
    
    private weak var surfaceView: WKWebView?
    
    func configure(with surfaceView: WKWebView) {
        self.surfaceView = surfaceView
        
        surfaceView.publisher(for: \.canGoBack)
            .receive(on: DispatchQueue.main)
            .assign(to: &$canGoBack)
        
        surfaceView.publisher(for: \.canGoForward)
            .receive(on: DispatchQueue.main)
            .assign(to: &$canGoForward)
        
        surfaceView.publisher(for: \.isLoading)
            .receive(on: DispatchQueue.main)
            .assign(to: &$isLoading)
        
        surfaceView.publisher(for: \.estimatedProgress)
            .receive(on: DispatchQueue.main)
            .assign(to: &$estimatedProgress)
        
        surfaceView.publisher(for: \.url)
            .receive(on: DispatchQueue.main)
            .assign(to: &$currentURL)
    }
    
    func goBack() {
        surfaceView?.goBack()
    }
    
    func goForward() {
        surfaceView?.goForward()
    }
    
    func reload() {
        surfaceView?.reload()
    }
    
    func load(url: URL) {
        let request = URLRequest(url: url)
        surfaceView?.load(request)
    }
}

