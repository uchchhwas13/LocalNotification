//
//  ContentView.swift
//  LocalNotification
//
//  Created by Uchchhwas Roy on 7/4/23.
//

import SwiftUI

struct NotificationListView: View {
    @StateObject private var notificationManger = NotificationManager()
    @State private var isCreatePresented = false
    
    private static var notificationDateFormatter: DateFormatter = {
        let dateFormatter  = DateFormatter()
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()
    
    private func timeDisplayText(from notification: UNNotificationRequest) -> String {
        guard let nextTriggerDate = (notification.trigger as? UNCalendarNotificationTrigger)?.nextTriggerDate() else {
            return ""
        }
        return NotificationListView.notificationDateFormatter.string(from: nextTriggerDate)
    }
    
    @ViewBuilder
    var infoOverlayView : some View {
        switch notificationManger.authorizationStatus {
        case .authorized:
            if notificationManger.notifications.isEmpty {
                InfoOverlayView(infoMessage: "No notifications yet", buttonTitle: "Create", systemImageName: "plus.circle") {
                    isCreatePresented = true
                }
            }
        case .denied:
            InfoOverlayView(infoMessage: "Please enable notification permission in settings", buttonTitle: "Settings", systemImageName: "gear") {
                if let url  = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
        default:
             EmptyView()
        }
    }

    var body: some View {
        List{
            ForEach(notificationManger.notifications, id: \.identifier) { notification in
                HStack {
                    Text(notification.content.title)
                        .fontWeight(.semibold)
                    Text(timeDisplayText(from:notification))
                        .fontWeight(.bold)
                    Spacer()
                }
            }
            .onDelete(perform: delete)
        }
        .listStyle(InsetGroupedListStyle())
        .overlay(infoOverlayView)
        .navigationTitle("Notifications")
        .onAppear(perform: notificationManger.reloadAuthorizationStatus)
        .onChange(of: notificationManger.authorizationStatus) {authorizationStatus in
            switch authorizationStatus {
            case .notDetermined:
                notificationManger.requestAuthorization()
                print("Requesting for authorization")
            case .authorized:
                notificationManger.reloadLocalNotifications()
                print("")
                
            default:
                print("")
            }
            
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification), perform: { _ in
            notificationManger.reloadAuthorizationStatus()
        })
        .navigationBarItems(trailing: Button{
            isCreatePresented = true 
        } label: {
            Image(systemName: "plus.circle")
                .imageScale(.large)
        })
        .sheet(isPresented: $isCreatePresented) {
            NavigationStack {
                CreateNotificationView(notificationManager: notificationManger, isPresented: $isCreatePresented)
            }
            .accentColor(.primary)
        }
    }
}

extension NotificationListView {
    func delete(_ indexSet: IndexSet) {
        notificationManger.deleteLocalNotifications(identifiers: indexSet.map { notificationManger.notifications[$0].identifier }
        )
        notificationManger.reloadLocalNotifications()
    }
}

struct NotificationListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            NotificationListView()
        }
        .accentColor(.primary)
    }
}
