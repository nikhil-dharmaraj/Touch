//
//  Contact.swift
//  Touch
//
//  Created by Nikhil Dharmaraj on 7/14/16.
//  Copyright © 2016 Nikhil Dharmaraj. All rights reserved.
//

import Foundation
import Contacts

class Contact {
    var name: String
    var number: String
    
    init(info: CNContact) {
        self.name = ContactsHelper.getName(info)
        self.number = ContactsHelper.getNumber(info)
    }
}