//
//  NotificationsHelper.swift
//  Touch
//
//  Created by Nikhil Dharmaraj on 7/19/16.
//  Copyright © 2016 Nikhil Dharmaraj. All rights reserved.
//

import Foundation
import UIKit
import Parse

class NotificationsHelper {
    
    static func launchNotifications() {
        UIApplication.shared.cancelAllLocalNotifications()
        
        let notification = UILocalNotification()
        let lastMessageDate = Date()
        let date = (Calendar.current as NSCalendar).date(byAdding: NSCalendar.Unit.hour, value: ViewControllersHelper.notificationAmountOfHours, to: lastMessageDate, options: NSCalendar.Options.init(rawValue: 0))
        notification.fireDate = date
        notification.timeZone = TimeZone.current
        notification.repeatInterval = ViewControllersHelper.notificationRepeatInterval
        notification.alertBody = "Let a friend know you're thinking of them!"
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
}
