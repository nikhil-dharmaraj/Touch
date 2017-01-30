//
//  MessageHelper.swift
//  Touch
//
//  Created by Nikhil Dharmaraj on 7/15/16.
//  Copyright © 2016 Nikhil Dharmaraj. All rights reserved.
//

import Foundation
import Parse

class MessageHelper {
    

    static func sendSMS(_ toNumber: String, imageName: String) {
        // Use your own details here
        let twilioSID = "AC64db74214cbf7981b2605b239107b14e"
        let twilioSecret = "a8ae8b0b9c808be291c81f2fac85063d"
        let fromNumber = "4156550854"
        let user = PFUser.current()!
        let message = "\(user["additional"]!) sent you this message on Touch! Download the app to check it out at https://itunes.apple.com/app/id1138385750"
        
        let mediaUrl = "https://sites.google.com/a/neobyapps.com/images/images/\(imageName).png"
        // Build the request
        
        var request = URLRequest(url: URL(string:"https://\(twilioSID):\(twilioSecret)@api.twilio.com/2010-04-01/Accounts/\(twilioSID)/Messages")!)

        request.httpMethod = "POST"
        request.httpBody = "From=\(fromNumber)&To=\(toNumber)&Body=\(message)&MediaUrl=\(mediaUrl)".data(using: String.Encoding.utf8)
        
        // Build the completion block and send the request
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            print("Finished")
            if let data = data, let responseDetails = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                // Success
                print("Response: \(responseDetails)")
            } else {
                // Failure
                print("Error: \(error)")
            }
        }).resume()
        
    }
   
    static func sendVerification(_ toNumber: String) -> String {
        // Use your own details here
        let twilioSID = "AC64db74214cbf7981b2605b239107b14e"
        let twilioSecret = "a8ae8b0b9c808be291c81f2fac85063d"
        let fromNumber = "4156550854"
        let rand = MessageHelper.randomNumberGenerator()
        let message = "Your verification code for Touch is \(rand)"
        // Build the request
        var request = URLRequest(url: URL(string:"https://\(twilioSID):\(twilioSecret)@api.twilio.com/2010-04-01/Accounts/\(twilioSID)/Messages")!)
        request.httpMethod = "POST"
        request.httpBody = "From=\(fromNumber)&To=\(toNumber)&Body=\(message)".data(using: String.Encoding.utf8)
        
        // Build the completion block and send the request
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            print("Finished")
            if let data = data, let responseDetails = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                // Success
                print("Response: \(responseDetails)")
            } else {
                // Failure
                print("Error: \(error)")
            }
        }).resume()
        
        return rand
        
    }
    
    static func randomNumberGenerator() -> String {
        let temp = Int(arc4random_uniform(10))
        var string = String(temp)
        for _ in 1...6 {
            string.append(Character(String(Int((arc4random_uniform(10))))))
        }
        return string
    }
}

