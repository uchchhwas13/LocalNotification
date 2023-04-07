//
//  LocalNotificationApp.swift
//  LocalNotification
//
//  Created by Uchchhwas Roy on 7/4/23.
//

import SwiftUI

@main
struct LocalNotificationApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                NotificationListView()
            }
            .accentColor(.primary)
        }
    }
}
