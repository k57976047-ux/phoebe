import Foundation
import UserNotifications

final class NotificationService {
    
    // MARK: - Properties
    
    static let shared = NotificationService()
    
    private let notificationCenter: UNUserNotificationCenter
    
    // MARK: - Initialization
    
    private init(notificationCenter: UNUserNotificationCenter = .current()) {
        self.notificationCenter = notificationCenter
    }
    
    // MARK: - Private Methods
    
    private func createNotificationContent(title: String, body: String, sound: Bool) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        if sound {
            content.sound = .default
        }
        return content
    }
    
    // MARK: - Public Methods
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    func scheduleBreakNotification(after interval: TimeInterval, soundEnabled: Bool) {
        let content = createNotificationContent(
            title: "Time for a break!",
            body: "You've been driving for a while. Stretch your legs!",
            sound: soundEnabled
        )
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        let request = UNNotificationRequest(identifier: "break_notification", content: content, trigger: trigger)
        
        notificationCenter.add(request)
    }
    
    func scheduleBreakOverNotification(after interval: TimeInterval, soundEnabled: Bool) {
        let content = createNotificationContent(
            title: "Break over!",
            body: "Time to hit the road safely",
            sound: soundEnabled
        )
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        let request = UNNotificationRequest(identifier: "break_over_notification", content: content, trigger: trigger)
        
        notificationCenter.add(request)
    }
    
    func cancelAllNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
    }
}

