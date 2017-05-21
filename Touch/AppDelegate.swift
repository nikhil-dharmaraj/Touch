//  AppDelegate.swift
//  Touch
//
//  Created by Nikhil Dharmaraj on 7/12/16.
//  Copyright © 2016 Nikhil Dharmaraj. All rights reserved.
//

import UIKit
import Parse
import ParseUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    static var validSession: Bool = false
    
    var parseLoginHelper: ParseLoginHelper?
    
    override init() {
        super.init()
        
        parseLoginHelper = ParseLoginHelper {[unowned self] user, error in
            // Initialize the ParseLoginHelper with a callback
            if let error = error {
                // 1
                ErrorHandling.defaultErrorHandler(error)
            } else  if let _ = user {
                // if login was successful, display the TabBarController
                // 2
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController")
                // 3
                self.window?.rootViewController!.present(tabBarController, animated:true, completion:nil)
            }
        }
    }
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let configuration = ParseClientConfiguration {
            $0.applicationId = "sKteVapuJBXvn5d0EU49ZFoeTr8S4mpbcVVBVTOj"
            $0.clientKey = "bW2REGrzSyaqIP830SeMpEzwbDAnr8m4ELk2RNM0"
            $0.server = "https://parseapi.back4app.com"
        }
        Parse.initialize(with: configuration)
        PFUser.enableRevocableSessionInBackground()
        self.presentLoginLaunch(launchOptions: launchOptions)
        return true

    }
    
    func presentLogin() {
        
        // check if we have logged in user
        // 2
        let user = PFUser.current()
        
        let startViewController: UIViewController
        
        
        if (user != nil) {
            // 3
            // if we have a user, set the TabBarController to be the initial view controller
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            startViewController = storyboard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
            AppDelegate.register()
            ViewControllersHelper.checkIfMessages()
            ContactsHelper.instance.refreshContacts()
        } else {
            // 4
            // Otherwise set the LoginViewController to be the first
            let loginViewController = LogInViewController()
            loginViewController.fields = [.usernameAndPassword, .signUpButton, .logInButton]
            loginViewController.delegate = parseLoginHelper
            loginViewController.logInView?.usernameField?.placeholder = "Phone Number"
            loginViewController.logInView?.passwordField?.isHidden = true
            loginViewController.signUpController = PFSignUpViewController()
            loginViewController.signUpController?.delegate = parseLoginHelper
            loginViewController.signUpController?.fields = [.additional, .signUpButton, .dismissButton]
            loginViewController.signUpController?.signUpView?.additionalField?.placeholder = "Full Name"
            loginViewController.signUpController?.signUpView?.passwordField?.isHidden = true
            loginViewController.signUpController?.signUpView?.usernameField?.placeholder = "Phone Number"
            let label = UILabel()
            label.text = "TOUCH"
            label.textColor = UIColor.lightGray
            label.font = UIFont(name: label.font.fontName, size: 60)
            label.sizeToFit()
            loginViewController.signUpController?.signUpView?.logo = label
            
            
            startViewController = loginViewController
        }
        
        // 5
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = startViewController
        self.window?.makeKeyAndVisible()
        
    }

    func presentLoginLaunch(launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        
        // check if we have logged in user
        // 2
        let user = PFUser.current()
        
        var startViewController: UIViewController
        
        let keyExists = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] != nil
        
        
        if (user == nil) {
            // 4
            // Otherwise set the LoginViewController to be the first
            let loginViewController = LogInViewController()
            loginViewController.fields = [.usernameAndPassword, .signUpButton, .logInButton]
            loginViewController.delegate = parseLoginHelper
            loginViewController.logInView?.usernameField?.placeholder = "Phone Number"
            loginViewController.logInView?.passwordField?.isHidden = true
            loginViewController.signUpController = PFSignUpViewController()
            loginViewController.signUpController?.delegate = parseLoginHelper
            loginViewController.signUpController?.fields = [.additional, .signUpButton, .dismissButton]
            loginViewController.signUpController?.signUpView?.additionalField?.placeholder = "Full Name"
            loginViewController.signUpController?.signUpView?.passwordField?.isHidden = true
            loginViewController.signUpController?.signUpView?.usernameField?.placeholder = "Phone Number"
            let label = UILabel()
            label.text = "TOUCH"
            label.textColor = UIColor.lightGray
            label.font = UIFont(name: label.font.fontName, size: 60)
            label.sizeToFit()
            loginViewController.signUpController?.signUpView?.logo = label
            
            
            startViewController = loginViewController
        } else if (keyExists) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            var BaseTabBarViewController: BaseTabBarViewController = storyboard.instantiateViewController(withIdentifier: "tabBarController") as! BaseTabBarViewController
            BaseTabBarViewController.defaultIndex = 0
            startViewController = BaseTabBarViewController
            AppDelegate.register()
            ViewControllersHelper.checkIfMessages()
            ContactsHelper.instance.refreshContacts()
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            var BaseTabBarViewController: BaseTabBarViewController = storyboard.instantiateViewController(withIdentifier: "tabBarController") as! BaseTabBarViewController
            startViewController = BaseTabBarViewController
            AppDelegate.register()
            ViewControllersHelper.checkIfMessages()
            ContactsHelper.instance.refreshContacts()
        }
        
        // 5
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = startViewController
        self.window?.makeKeyAndVisible()
        
    }
    
    
    
    static func register() {
        let types: UIUserNotificationType = [.alert, .badge, .sound]
        let settings = UIUserNotificationSettings(types: types, categories: nil)
        let application = UIApplication.shared
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let installation = PFInstallation.current()
        installation["user"] = PFUser.current()!
        installation.setDeviceTokenFrom(deviceToken)
        installation.saveInBackground()
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        PFPush.handle(userInfo)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return true
    }
    
    
    
}

