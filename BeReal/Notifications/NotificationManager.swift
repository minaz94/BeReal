//
//  NotificationManager.swift
//  BeReal
//
//  Created by Mina on 3/14/24.
//

import UIKit
import UserNotifications

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    
    static let shared = NotificationManager()
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    func requestPermission() {
        notificationCenter.delegate = self
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { isAuthorized, error in
            if let error {
                print(error.localizedDescription)
            }
            var userAuth = ""
            isAuthorized ? (userAuth = "authenticated") : (userAuth = "not authenticated")
            print(userAuth)
        }
    }
    
    func removePendingNotification() {
        notificationCenter.removeAllPendingNotificationRequests()
    }
    
    func scheduleDailyNotification() {
        let content = UNMutableNotificationContent()
        content.title = "It's time!"
        content.body = "Post a photo for the day"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 24*60*60, repeats: true)
        
        let request = UNNotificationRequest(identifier: "reminder", content: content, trigger: trigger)
        notificationCenter.add(request)
    }
    
    func scheduleTestNotification() {
        let content = UNMutableNotificationContent()
        content.title = "It's time!"
        content.body = "Post a photo for the day"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: "test", content: content, trigger: trigger)
        notificationCenter.add(request)
    }
    
}
