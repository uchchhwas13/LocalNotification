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
}
