import Foundation

enum FlowLaunchMode: Equatable {
    case nativeApp
    case surfaceContent(URL)
    case surfaceFallback
}

enum FlowStableState: Equatable {
    case undecided
    case nativeOnly
    case surfaceWithActiveLink
    case surfaceWithInactiveLink
}

struct FlowLaunchResult: Equatable {
    let mode: FlowLaunchMode
    let stableState: FlowStableState
    let pathId: String?
    let savedURL: URL?
    let launchCount: Int
    let hasEverShownSurface: Bool
}

extension FlowLaunchResult {
    init(engine: T4X) {
        let resolvedMode: FlowLaunchMode
        switch engine.q1 {
        case .v2:
            resolvedMode = .nativeApp
        case .v3:
            if let url = engine.u1 {
                resolvedMode = .surfaceContent(url)
            } else {
                resolvedMode = .surfaceFallback
            }
        case .v4:
            resolvedMode = .surfaceFallback
        case .v1:
            if let url = engine.u1 {
                resolvedMode = .surfaceContent(url)
            } else {
                resolvedMode = .nativeApp
            }
        }
        
        let pathId = engine.s5.s3
        let savedURL = engine.s5.s2.flatMap { URL(string: $0) }
        let launchCount = engine.s5.n1
        let hasEverShownSurface = engine.s5.b1
        
        let stableState: FlowStableState
        if engine.s5.b2 {
            stableState = .nativeOnly
        } else if engine.s5.b1 {
            switch resolvedMode {
            case .surfaceContent:
                stableState = .surfaceWithActiveLink
            case .surfaceFallback:
                stableState = .surfaceWithInactiveLink
            case .nativeApp:
                stableState = .surfaceWithActiveLink
            }
        } else {
            stableState = .undecided
        }
        
        self.init(
            mode: resolvedMode,
            stableState: stableState,
            pathId: pathId,
            savedURL: savedURL,
            launchCount: launchCount,
            hasEverShownSurface: hasEverShownSurface
        )
    }
}

@MainActor
final class FlowLaunchService {
    
    static let shared = FlowLaunchService()
    
    private let engine = T4X()
   
    
    func performLaunchFlow() async -> FlowLaunchResult {
       
        await engine.f9()
        let result = FlowLaunchResult(engine: engine)
        
       
        
        return result
    }
    
    static func evaluateOnLaunch() async -> FlowLaunchResult {
      
        return await FlowLaunchService.shared.performLaunchFlow()
    }
}

