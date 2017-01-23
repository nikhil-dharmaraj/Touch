//
//  VerifyViewController.swift
//  Touch
//
//  Created by Nikhil Dharmaraj on 12/26/16.
//  Copyright © 2016 Nikhil Dharmaraj. All rights reserved.
//

import Foundation
import UIKit
import ParseUI
import libPhoneNumber_iOS

class VerifyViewController: UIViewController {
    
    var correctCode: String?

    var user: PFUser?
    
    let phoneUtil = NBPhoneNumberUtil()
    
    var number: String?
    
    @IBOutlet weak var code: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let thePadding = UIView(frame: CGRect(x: 0, y: 0, width: 17, height: 17))
        code.leftView = thePadding
        code.leftViewMode = UITextFieldViewMode.always
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(VerifyViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(VerifyViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height/4
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height/4
            }
        }
    }
    
    @IBAction func verifyButtonPressed(_ sender: AnyObject) {
        
        if code.text! != "" && code.text!.characters.count == 7 {
            
            let enteredCode = code.text!
            if enteredCode == correctCode {
                do {
                    let phoneNumber: NBPhoneNumber = try phoneUtil.parse(number, defaultRegion: "US")
                    let formattedString: String = try phoneUtil.format(phoneNumber, numberFormat: .E164)
                    PFUser.logInWithUsername (inBackground: formattedString, password: "##", block: { (user: PFUser?, error: Error?) in
                        if error == nil {
                            self.performSegue (withIdentifier: "toTab", sender: self)
                            ContactsHelper.instance.refreshContacts()
                        }
                        else {
                            ErrorHandling.defaultErrorHandler(error! as NSError)
                        }
                        
                    })
                }
                catch let error as NSError {
                    print(error.localizedDescription)
                }
                
            }
            else {
                let alertController = UIAlertController(title: "Incorrect Code", message: "Please try again", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default) {(action) in
                }
                
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
                
                code.text = ""
            }
        }
        else {
            let alertController = UIAlertController(title: "Text Field", message: "Please enter a 7 digit verification code", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) {(action) in
            }
            
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
            
            code.text = ""
        }
    }
    

}
