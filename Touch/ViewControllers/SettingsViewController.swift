//
//  SettingsViewController.swift
//  Touch
//
//  Created by Nikhil Dharmaraj on 7/12/16.
//  Copyright © 2016 Nikhil Dharmaraj. All rights reserved.
//

import UIKit
import ParseUI

class SettingsViewController: UIViewController {

    @IBOutlet weak var accessButton: UIButton!
    
    @IBOutlet weak var logOutButton: UIButton!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.accessButton.layer.borderWidth = 1
        self.accessButton.layer.borderColor = self.accessButton.currentTitleColor.cgColor
        self.logOutButton.layer.borderWidth = 1
        self.logOutButton.layer.borderColor = self.accessButton.currentTitleColor.cgColor
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func changeNotificationsButtonPressed(_ sender: AnyObject) {
        
        UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
    }

    @IBAction func logOutButtonPressed(_ sender: AnyObject) {
        
        PFUser.logOut()
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.presentLogin()
    }
    
    @IBAction func unwindToSettingsViewCOntroller(_ segue: UIStoryboardSegue) {
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
