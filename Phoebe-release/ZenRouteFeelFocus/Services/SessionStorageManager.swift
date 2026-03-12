import Foundation
import WebKit

final class SessionStorageManager {
    
    static let shared = SessionStorageManager()
    
    private let userDefaultsKey = "session.storage"
    
    private init() {}
    
    func saveCookies(from surfaceView: WKWebView) {
        let store = surfaceView.configuration.websiteDataStore.httpCookieStore
        store.getAllCookies { [weak self] cookies in
            guard let self else { return }
            
            let serialized = cookies.compactMap { cookie -> [String: Any]? in
                var payload: [String: Any] = [
                    "name": cookie.name,
                    "value": cookie.value,
                    "domain": cookie.domain,
                    "path": cookie.path,
                    "isSecure": cookie.isSecure,
                    "isHTTPOnly": cookie.isHTTPOnly
                ]
                
                if let expiresDate = cookie.expiresDate {
                    payload["expiresDate"] = expiresDate.timeIntervalSince1970
                }
                
                if let policy = cookie.sameSitePolicy {
                    payload["sameSitePolicy"] = policy.rawValue
                }
                
                return payload
            }
            
            guard let data = try? JSONSerialization.data(withJSONObject: serialized, options: []) else {
                return
            }
            
            UserDefaults.standard.set(data, forKey: self.userDefaultsKey)
        }
    }
    
    func loadCookies(into surfaceView: WKWebView, completion: (() -> Void)? = nil) {
        guard
            let data = UserDefaults.standard.data(forKey: userDefaultsKey),
            let serialized = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
        else {
            completion?()
            return
        }
        
        let store = surfaceView.configuration.websiteDataStore.httpCookieStore
        let group = DispatchGroup()
        
        serialized.forEach { payload in
            guard
                let name = payload["name"] as? String,
                let value = payload["value"] as? String,
                let domain = payload["domain"] as? String,
                let path = payload["path"] as? String
            else {
                return
            }
            
            var properties: [HTTPCookiePropertyKey: Any] = [
                .name: name,
                .value: value,
                .domain: domain,
                .path: path
            ]
            
            if let expires = payload["expiresDate"] as? TimeInterval {
                properties[.expires] = Date(timeIntervalSince1970: expires)
            }
            
            if let isSecure = payload["isSecure"] as? Bool, isSecure {
                properties[.secure] = "TRUE"
            }
            
            if let isHTTPOnly = payload["isHTTPOnly"] as? Bool, isHTTPOnly {
                properties[.init("HttpOnly")] = "TRUE"
            }
            
            if let sameSite = payload["sameSitePolicy"] as? String {
                properties[.sameSitePolicy] = sameSite
            }
            
            guard let cookie = HTTPCookie(properties: properties) else { return }
            
            group.enter()
            store.setCookie(cookie) {
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion?()
        }
    }
    
    func clearCookies() {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
    }
}

