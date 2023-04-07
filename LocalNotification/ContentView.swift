//
//  ContentView.swift
//  LocalNotification
//
//  Created by Uchchhwas Roy on 7/4/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var notificationManger = NotificationManager()
    @State private var isCreatePresented = false
    var body: some View {
        List(notificationManger.notifications, id: \.identifier) {notification in
            Text(notification.content.title)
                .fontWeight(.semibold)
        }
        .listStyle(InsetGroupedListStyle())
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
            
        }.navigationBarItems(trailing: Button{
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ContentView()
        }
        .accentColor(.primary)
    }
}
