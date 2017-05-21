//
//  ViewControllersHelper.swift
//  Touch
//
//  Created by Nikhil Dharmaraj on 7/17/16.
//  Copyright © 2016 Nikhil Dharmaraj. All rights reserved.
//

import Foundation
import MessageUI
import Parse

class ViewControllersHelper {
    
    static let notificationAmountOfHours = 24
    static let notificationRepeatInterval = NSCalendar.Unit.day
    
    static func checkIfMessages() {
            ParseHelper.getMessageCount(block: { (results: [PFObject]?) in
                if results?.count != 0 {
                    ParseHelper.hasMessages = true
                }
            })
    }
    
    static func checkIfMessagesFromInbox(viewController: InboxViewController) {
        ParseHelper.getMessageCount(block: { (results: [PFObject]?) in
            if results?.count != 0 {
                ParseHelper.hasMessages = true
                viewController.tableView.reloadData()
            }
        })
    }
    
}
