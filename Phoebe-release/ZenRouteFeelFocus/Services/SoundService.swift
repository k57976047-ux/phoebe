import Foundation
import AVFoundation

final class SoundService {
    
    // MARK: - Properties
    
    static let shared = SoundService()
    
    private var players: [SoundType: AVAudioPlayer] = [:]
    
    // MARK: - Nested Types
    
    enum SoundType {
        case start
        case pause
        case resume
        case breakAlert
        case breakStart
        case breakComplete
        case stop
        
        var systemSoundID: SystemSoundID {
            switch self {
            case .start:
                return 1057
            case .pause:
                return 1054
            case .resume:
                return 1057
            case .breakAlert:
                return 1312
            case .breakStart:
                return 1070
            case .breakComplete:
                return 1113
            case .stop:
                return 1105
            }
        }
    }
    
    // MARK: - Initialization
    
    private init() {
        configureAudioSession()
    }
    
    // MARK: - Private Methods
    
    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            // Audio session configuration failed
        }
    }
    
    // MARK: - Public Methods
    
    func playSound(_ type: SoundType) {
        AudioServicesPlaySystemSound(type.systemSoundID)
    }
    
    func playSound(_ type: SoundType, if condition: Bool) {
        guard condition else { return }
        playSound(type)
    }
}

