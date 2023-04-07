//
//  ContentView.swift
//  LocalNotification
//
//  Created by Uchchhwas Roy on 7/4/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var notificationManger = NotificationManager()
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
                //get local notification
                print("")
                
            default:
                print("")
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
