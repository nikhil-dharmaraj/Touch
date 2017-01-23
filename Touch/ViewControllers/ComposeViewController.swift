
//
//  ComposeViewController.swift
//  Touch
//
//  Created by Nikhil Dharmaraj on 7/23/16.
//  Copyright © 2016 Nikhil Dharmaraj. All rights reserved.
//

import UIKit
import Parse

class ComposeViewController: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var constraint: NSLayoutConstraint!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var button2: UIButton!
    var randomContact: Contact?
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.revert()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func deleteButtonPressed(_ sender: AnyObject) {
        self.showAlertTwo()
    }
    
  
    @IBAction func spinButtonPressed(_ sender: AnyObject) {
        self.spin()
    }
    
    func revert() {
        self.imageView.isHidden = false
        self.button.isHidden = true
        self.button2.isHidden = true
        self.headerLabel.isHidden = false
        self.label.text = ""
    }
    
    func spin() {
        let user = PFUser.current()!
        if user["firstSpin"] == nil {
            NotificationsHelper.launchNotifications()
            user["firstSpin"] = true
            user.saveInBackground()
        }
        self.imageView.isHidden = false
        self.label.text = ""
        self.button.isHidden = true
        self.button2.isHidden = true
        UIView.animate (withDuration: 2, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
                self.imageView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
                self.imageView.transform = CGAffineTransform.identity
                }, completion: {(bool: Bool) in
                    if ContactsHelper.instance.contacts.count == 0 {
                        self.showAlertOne()
                    }
                    else {
                        let modelName = UIDevice.current.modelName
                        let randIndex = Int(arc4random_uniform(UInt32(ContactsHelper.instance.contacts.count)))
                        self.randomContact = ContactsHelper.instance.contacts[randIndex]
                        if modelName == "iPhone 4s" {
                            self.imageView.isHidden = true
                            self.constraint.isActive = false
                            self.button.setTitle("  Message \(self.randomContact!.name) now!  ", for: UIControlState())
                            self.button2.setTitle("          Delete from Touch          ", for: UIControlState())
                        }
                        else {
                            if modelName == "iPhone 5s" || modelName == "iPhone 5" {
                                self.headerLabel.isHidden = true
                            }
                            self.button.setTitle("  Message now!  ", for: UIControlState())
                            self.button2.setTitle("  Delete from Touch  ", for: UIControlState())
                            self.label.text = "Let \(self.randomContact!.name) know you're thinking of them!"
                        }
                        self.button.isHidden = false
                        self.button2.isHidden = false
                        self.button.layer.borderWidth = 1
                        self.button.layer.borderColor = self.label.textColor.cgColor
                    }
            })
    }
    
    func showAlertOne() {
        
        let alertController = UIAlertController(title: "Access to contacts restricted", message: "Please enable access to contacts before sending a message", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) {(action) in
        }
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func showAlertTwo() {
        
        let alertController = UIAlertController(title: "Are you sure you want to delete this contact from Touch?", message: "", preferredStyle: .alert)
        
        let yes = UIAlertAction(title: "Yes", style: .default) {(action) in
            ParseHelper.deleteContact(self.randomContact!, controller: self)
        }
        
        alertController.addAction(yes)
        
        let no = UIAlertAction(title: "No", style: .cancel) {(action) in
        }
        
        alertController.addAction(no)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func unwindToComposeViewController(_ segue: UIStoryboardSegue) {
    }
    
    override func prepare (for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toChoose" {
            let destination = segue.destination as! ChooseMessageViewController
            destination.recipient = self.randomContact
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPhone4,1":                               return "iPhone 4s"
        case "i386", "x86_64":                          return "Simulator"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        default:                                        return identifier
        }
    }
    
}
