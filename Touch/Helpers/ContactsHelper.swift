//
//  ContactsHelper.swift
//  Touch
//
//  Created by Nikhil Dharmaraj on 7/14/16.
//  Copyright © 2016 Nikhil Dharmaraj. All rights reserved.
//

import Foundation
import Contacts
import Parse
import libPhoneNumber_iOS

class ContactsHelper {
    
    static let instance = ContactsHelper()
    
    var contacts: [Contact] = []
    
    func refreshContacts() {
        contacts = []
        let user = PFUser.current()!
        let deleted = user["deletedContacts"] as? [String]
        let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
        let store = CNContactStore()
        let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch as [CNKeyDescriptor])
           do {
            try store.enumerateContacts(with: fetchRequest, usingBlock: { (contact: CNContact, pointer: UnsafeMutablePointer<ObjCBool>) in
                if (contact.phoneNumbers.count != 0) {
                    let num = ContactsHelper.getNumber(contact)
                    if (deleted == nil || !deleted!.contains(num)) {
                        self.contacts.append(Contact(info: contact))
                    }
                }
            })
           }
        catch {
            print ("Error!")
        }
    }

    static func getNumber(_ contact: CNContact) -> String {
        var phoneNum = ""
        if contact.isKeyAvailable(CNContactPhoneNumbersKey) {
            if contact.phoneNumbers.count > 0 {
                phoneNum = ((contact.phoneNumbers.first?.value)! as CNPhoneNumber).stringValue
            }
        }
        
        return normalizeNumber(phoneNum)
    }
    
//    static func getNumber(_ contact: CNContact) -> String {
//            var number = ""
//            for num in contact.phoneNumbers {
//                if num.label == CNLabelPhoneNumberMobile || num.label == CNLabelPhoneNumberiPhone || num.label == CNLabelPhoneNumberMain {
//                    //number = num.value(forKey: "digits") as! String
//                    number = (contact.phoneNumbers.first?.value as? CNPhoneNumber)?.stringValue
//                    
//                    return normalizeNumber(number)
//                }
//            }
//            number = (contact.phoneNumbers[0].value(forKey: "digits")) as! String
//            return normalizeNumber(number)
//    }
    
    static func getName(_ contact: CNContact) -> String {
        if (contact.isKeyAvailable(CNContactGivenNameKey) && contact.isKeyAvailable(CNContactFamilyNameKey)) {
            return contact.givenName + " " + contact.familyName
        }
        return ""
    }
    
    static func normalizeNumber(_ number: String) -> String {
        let phoneUtil = NBPhoneNumberUtil()
        var formattedString: String = ""
        do {
            let phoneNumber: NBPhoneNumber = try phoneUtil.parse(number, defaultRegion: "US")
            formattedString = try phoneUtil.format(phoneNumber, numberFormat: .E164)
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        return formattedString
    }

}
