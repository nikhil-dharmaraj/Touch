//
//  InboxMessageTableViewCell.swift
//  Touch
//
//  Created by Nikhil Dharmaraj on 7/12/16.
//  Copyright © 2016 Nikhil Dharmaraj. All rights reserved.
//

import UIKit
import Parse

class InboxMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var thankButton: UIButton!
    @IBOutlet weak var contactInfo: UILabel!
    @IBOutlet weak var messageImage: UIImageView!
    

    var message: PFObject? {
        didSet {
            if let message = message {
                if message["thanked"] == nil {
                    self.thankButton.isHidden = true
                }
                else {
                    self.thankButton.isHidden = false
                    self.thankButton.isSelected = message["thanked"] as! Bool
                    self.thankButton.isUserInteractionEnabled = !self.thankButton.isSelected
                }
                let user = message["fromUser"] as! PFUser
                
                //                let number = user["username"]
                //                var text: String = "\(number) sent you a"
                //                for contact in ContactsHelper.instance.contacts {
                //                    if contact.number == number {
                //                        text = "\(contact.name) sent you a"
                //                    }
                //                }

                
                let name = user["additional"] as! String
                let text: String = "\(name) sent you a"
                self.contactInfo.text = text
                  message.saveInBackground()
            }
        }
    }
    
    @IBAction func thankButtonPressed(_ sender: AnyObject) {
        if let message = self.message {
            if self.thankButton.isSelected == false {
                self.thankButton.isSelected = true
                self.thankButton.isUserInteractionEnabled = false
                ParseHelper.thankMessage(message)
            }
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
