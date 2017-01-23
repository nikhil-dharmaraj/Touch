//
//  ParseHelper.swift
//  Touch
//
//  Created by Nikhil Dharmaraj on 7/13/16.
//  Copyright © 2016 Nikhil Dharmaraj. All rights reserved.
//

import Foundation
import Parse
import MessageUI
import ARSLineProgress

class ParseHelper {
    
    static func saveMessage(_ toUser: Contact, image: UIImage, controller: UIViewController, imageName: String)  {
        ARSLineProgress.showWithProgressObject(Progress())
        let query = PFUser.query()!
        query.whereKey("username", equalTo: toUser.number)
        query.findObjectsInBackground { (users: [PFObject]?, error: Error?) in
            if let error = error {
                ErrorHandling.defaultErrorHandler(error as NSError)
            }
            else if users!.count != 0 {
                let recipient = users![0] as? PFUser
                let message = PFObject(className: "Message")
                message["fromUser"] = PFUser.current()
                guard let imageData = UIImageJPEGRepresentation(image, 0.8) else {return}
                guard let imageFile = PFFile(name: "image.jpg", data: imageData) else {return}
                message["image"] = imageFile
                message["toUser"] = recipient
                message["thanked"] = false
                message.saveInBackground(block: { (bool, error) in
                    if let error = error {
                        ErrorHandling.defaultErrorHandler(error as NSError)
                    }
                    else {
                        DispatchQueue.main.async {
                            ARSLineProgress.updateWithProgress(1.0)
                            ARSLineProgress.showSuccess()
                            controller.performSegue(withIdentifier: "toInbox", sender: controller)
                        }
                    }
                })
                let currentUser = PFUser.current()!
                currentUser["lastMessageSent"] = NSDate()
                if currentUser["firstMessageSent"] == nil {
                    currentUser["firstMessageSent"] = true
                }
                currentUser.saveInBackground()
            }
                
            else {
                MessageHelper.sendSMS(toUser.number, imageName: imageName)
                DispatchQueue.main.async {
                    ARSLineProgress.updateWithProgress(1.0)
                    ARSLineProgress.showSuccess()
                    controller.performSegue(withIdentifier: "toInbox", sender: controller)
                }
            }
        }
    }
    
    static func getMessagesForUser(_ range: Range<Int>, block: @escaping (_ results:[PFObject]?) -> Void) {
        let messageQuery = PFQuery(className: "Message")
        messageQuery.whereKey("toUser", equalTo: PFUser.current()!)
        messageQuery.includeKey("fromUser")
        messageQuery.order(byDescending: "createdAt")
        messageQuery.skip = range.lowerBound
        messageQuery.limit = range.upperBound - range.lowerBound
        messageQuery.findObjectsInBackground { (results, error) in
            block(results)
        }
    }
    
    static func checkIfUserExists(_ username: String, block: @escaping (_ results:[PFObject]?) -> Void) {
        let userQuery = PFUser.query()!
        userQuery.whereKey("username", equalTo: username)
        userQuery.findObjectsInBackground { (results, error) in
            block(results)
        }
    }
    
    static func deleteContact(_ contact: Contact, controller: ComposeViewController) {
        let user = PFUser.current()!
        let number = contact.number
        let contacts = user["deletedContacts"]
        var arr: [String] = []
        if contacts == nil {
            arr = [number]
        }
        else {
            arr = contacts as! [String]
            arr.append(number)
        }
        user["deletedContacts"] = arr
        user.saveInBackground()
        ContactsHelper.instance.refreshContacts()
        controller.revert()
    }
    
    
    static func downloadImage(_ imageFile: PFFile?, cell: InboxMessageTableViewCell) {
        imageFile?.getDataInBackground { (data: Data?, error: Error?) -> Void in
            if let error = error {
                ErrorHandling.defaultErrorHandler(error as NSError)
            }
            else {
                let image = UIImage(data: data!, scale:1.0)!
                cell.messageImage.image = image
            }
        }
        
    }
    
    static func getFirstObject(_ username: String) -> PFObject? {
        let userQuery = PFUser.query()!
        userQuery.whereKey("username", equalTo: username)
        var firstObject: PFObject?
        do {
            try firstObject = userQuery.getFirstObject()
        }
        catch {
            
        }
        return firstObject
    }
    
    static func thankMessage(_ message: PFObject) {
        let thank = PFObject(className: "Message")
        thank["fromUser"] = PFUser.current()
        thank["toUser"] = message["fromUser"]
        guard let imageData = UIImageJPEGRepresentation(UIImage(named: "THANKS")!, 0.8) else {return}
        guard let imageFile = PFFile(name: "image.jpg", data: imageData) else {return}
        thank["image"] = imageFile
        message["thanked"] = true
        message.saveInBackground()
        thank.saveInBackground()
    }
    
    //    static func validateSession() {
    //        let query = PFQuery(className: "Dummy")
    //        do {
    //            try query.findObjects()
    //            AppDelegate.validSession = true
    //        }
    //        catch {
    //            AppDelegate.validSession = true
    //        }
    //    }
}


extension PFObject {
    
    open override func isEqual(_ object: Any?) -> Bool {
        if (object as? PFObject)?.objectId == self.objectId {
            return true
        } else {
            return super.isEqual(object)
        }
    }
    
}

