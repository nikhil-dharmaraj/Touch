//
//  InboxViewController.swift
//  Touch
//
//  Created by Nikhil Dharmaraj on 7/12/16.
//  Copyright © 2016 Nikhil Dharmaraj. All rights reserved.
//

import UIKit
import Parse
import ConvenienceKit
import ARSLineProgress


class InboxViewController: UIViewController, TimelineComponentTarget {
    
    typealias ContentType = PFObject

    var timelineComponent: TimelineComponent<PFObject, InboxViewController>!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var defaultRange: Range<Int> = 0..<5
    var additionalRangeSize: Int = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timelineComponent = TimelineComponent(target: self)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        timelineComponent.loadInitialIfRequired()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if ParseHelper.queryChanged == nil {
            ViewControllersHelper.checkIfMessagesFromInbox(viewController: self)
        }
        if ParseHelper.queryChanged == true {
            tableView.reloadData()
            ParseHelper.queryChanged = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func loadInRange(_ range: Range<Int>, completionBlock: @escaping ([PFObject]?) -> Void) {
        // 1
        ParseHelper.getMessagesForUser(range) { (result) in
            // 2
//            if let error = error {
//                ErrorHandling.defaultErrorHandler(error as NSError)
//            }
            let messages = result ?? []
            // 3
            completionBlock(messages)
        }
    }
    
    
    @IBAction func unwindToInboxViewController(_ segue: UIStoryboardSegue) {
    }

    func prepareFoSegue (_ segue: UIStoryboardSegue, sender: Any?) {
        
        if let identifier = segue.identifier {
            // 2
            if identifier == "sendMessage" {
                // 3
                print("Transitioning to the Send Message View Controller")
            }
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

extension InboxViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ParseHelper.hasMessages == false {
            tableView.isHidden = true
            label.text = "You have no messages!"
            return 0
        }
        label.text = ""
        tableView.isHidden = false
        return timelineComponent.content.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.isHidden = false
        let cell = tableView.dequeueReusableCell(withIdentifier: "inboxMessage") as! InboxMessageTableViewCell
        let message = timelineComponent.content[indexPath.row]
        cell.message = message
        cell.messageImage.image = nil
        ParseHelper.downloadImage(message["image"] as? PFFile, cell: cell)
        return cell
    }
    
}

extension InboxViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        timelineComponent.targetWillDisplayEntry(indexPath.row)
    }
    
}
