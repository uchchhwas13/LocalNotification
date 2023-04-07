//
//  NotificationManager.swift
//  LocalNotification
//
//  Created by Uchchhwas Roy on 7/4/23.
//

import Foundation
import UserNotifications
final class NotificationManager: ObservableObject {
    @Published private(set) var notifications: [UNNotificationRequest] = []
    @Published private(set) var authorizationStatus: UNAuthorizationStatus?

    func reloadAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: {settings in
            DispatchQueue.main.async {
                self.authorizationStatus = settings.authorizationStatus
            }
        })
    }
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge, .sound]) { isGranted, _ in
            DispatchQueue.main.async {
                self.authorizationStatus = isGranted ? .authorized : .denied 
            }
        }
    }
    
    func reloadLocalNotifications() {
        print("Reload notifications")
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in
            DispatchQueue.main.async {
                self.notifications = notifications
            }
        }
    }
    
    func createLocalNotification(title: String, hour: Int, min: Int, completion: @escaping (Error?)-> Void) {
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = min
        //dateComponents.weekday = 1
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.sound = .default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: completion)
    }
}
