import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

    func requestPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
            completion(granted)
        }
    }

    func scheduleFullMoonNotification(date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Pleine Lune"
        content.body = "C'est la pleine lune aujourd'hui !"
        content.sound = .default

        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        let request = UNNotificationRequest(identifier: "FullMoon-\(date.timeIntervalSince1970)", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
