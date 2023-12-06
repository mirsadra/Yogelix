//  NotificationManager.swift
import UserNotifications

class NotificationManager {

    func scheduleDailyReminder() {
        let content = UNMutableNotificationContent()
        content.title = "Daily Yoga Challenge"
        content.body = "Check out today's yoga challenge!"

        var dateComponents = DateComponents()
        dateComponents.hour = 8 // Example: 8 AM every day
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(identifier: "dailyChallengeReminder", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
