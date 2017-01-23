//
//  LogInViewController.swift
//  Touch
//
//  Created by Nikhil Dharmaraj on 7/21/16.
//  Copyright © 2016 Nikhil Dharmaraj. All rights reserved.
//

import UIKit
import ParseUI

class LogInViewController: PFLogInViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let label = UILabel()
        label.text = "TOUCH"
        label.textColor = UIColor.lightGray
        label.font = UIFont(name: label.font.fontName, size: 60)
        label.sizeToFit()
        logInView?.logo = label
                
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
