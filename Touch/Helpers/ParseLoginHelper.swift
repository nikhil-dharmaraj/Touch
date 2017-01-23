//
//  ParseLoginHelper.swift
//  Makestagram
//
//  Created by Benjamin Encz on 4/15/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import Foundation
import Parse
import ParseUI
import libPhoneNumber_iOS

typealias ParseLoginHelperCallback = (PFUser?, NSError?) -> Void

/**
 This class implements the 'PFLogInViewControllerDelegate' protocol. After a successfull login
 it will call the callback function and provide a 'PFUser' object.
 */
class ParseLoginHelper : NSObject {
    let callback: ParseLoginHelperCallback
    
    let phoneUtil = NBPhoneNumberUtil()
    
    init(callback: @escaping ParseLoginHelperCallback) {
        self.callback = callback
    }
    
    func isValidPhoneNumber(_ number: String) -> Bool {
        do {
            let phoneNumber: NBPhoneNumber = try phoneUtil.parse(number, defaultRegion: "US")
            return phoneUtil.isValidNumber(phoneNumber)
        }
        catch let error as NSError {
            print(error.localizedDescription)
            return false
        }
    }
    
    func normalizeNumber(_ number: String) -> String {
        do {
            let phoneNumber: NBPhoneNumber = try phoneUtil.parse(number, defaultRegion: "US")
            let formattedString: String = try phoneUtil.format(phoneNumber, numberFormat: .E164)
            return formattedString
        }
        catch let error as NSError {
            print(error.localizedDescription)
            return ""
        }
    }
}

extension ParseLoginHelper : PFLogInViewControllerDelegate {
    
    
    
    func log(_ logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {

        do {
            let phoneNumber: NBPhoneNumber = try phoneUtil.parse(username, defaultRegion: "US")
            let formattedString: String = try phoneUtil.format(phoneNumber, numberFormat: .E164)    

            ParseHelper.checkIfUserExists(formattedString, block: { (results) in
                if let results = results {
                    if results.count != 0 {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let verify = storyboard.instantiateViewController(withIdentifier: "verify") as! VerifyViewController
                        verify.correctCode = MessageHelper.sendVerification(username)
                        verify.number = username
                        logInController.present(verify, animated: true, completion: nil)
                        
                    }
                    else {
                        let alertController = UIAlertController(title: "This account does not exist", message: "Please sign up first", preferredStyle: .alert)
                        
                        let okAction = UIAlertAction(title: "OK", style: .default) {(action) in
                        }
                        
                        alertController.addAction(okAction)
                        
                        logInController.present(alertController, animated: true, completion: nil)
                    }
                }
            })
            
        }
        catch {
            let alertController = UIAlertController(title: "Invalid Phone Number", message: "Please enter a valid phone number", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) {(action) in
            }
            
            alertController.addAction(okAction)
            
            logInController.present(alertController, animated: true, completion: nil)
        }
        return false
    }
}

extension ParseLoginHelper: PFSignUpViewControllerDelegate {
    
    
    func signUpViewController(_ signUpController: PFSignUpViewController, didSignUp user: PFUser) {
        user["password"] = "##"
        user["username"] = normalizeNumber(user["username"] as! String)
        user.saveInBackground(block: { (bool: Bool, error: Error?) in
            if bool {
                PFUser.logOut()
                self.transitionToVerify(signUpController, user: user)
                
            }
            else {
                ErrorHandling.defaultErrorHandler(error! as NSError)
            }
        })
        
    }
    
    func signUpViewController(_ signUpController: PFSignUpViewController, didFailToSignUpWithError error: Error?) {
        if let _ = error {
            let alertController = UIAlertController(title: "Check Phone Number", message: "This phone number is already in use with another account", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) {(action) in
            }
            
            alertController.addAction(okAction)
            
            signUpController.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    func signUpViewController(_ signUpController: PFSignUpViewController, shouldBeginSignUp info: [String : String]) -> Bool {
        if info["username"] == "" || info["additional"] == "" || !isValidPhoneNumber(info["username"]!) {
            let alertController = UIAlertController(title: "Invalid Fields", message: "Please make sure your phone number and full name are valid", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) {(action) in
            }
            
            alertController.addAction(okAction)
            
            signUpController.present(alertController, animated: true, completion: nil)
            return false
        }
        
        var bool: Bool = true
        let formattedString = normalizeNumber(info["username"]!)
        let firstObject = ParseHelper.getFirstObject(formattedString)
        if let _ = firstObject {
            let alertController = UIAlertController(title: "Check Phone Number", message: "This phone number is already in use with another account", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) {(action) in
            }
            
            alertController.addAction(okAction)
            
            signUpController.present(alertController, animated: true, completion: nil)
            bool = false
        }
        return bool
    }
    
    func transitionToVerify(_ signUpController: PFSignUpViewController, user: PFUser) {
        let phoneNumber = user["username"] as! String
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let verify = storyboard.instantiateViewController(withIdentifier: "verify") as! VerifyViewController
        verify.correctCode = MessageHelper.sendVerification(phoneNumber)
        verify.user = user
        verify.number = (user["username"] as! String)
        signUpController.present(verify, animated: true, completion: nil)
    }
    
}

