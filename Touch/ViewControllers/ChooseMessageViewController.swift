//
//  ChooseMessageViewController.swift
//  Touch
//
//  Created by Nikhil Dharmaraj on 7/12/16.
//  Copyright © 2016 Nikhil Dharmaraj. All rights reserved.
//

import UIKit
import MessageUI

class ChooseMessageViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
 
    var images: [UIImage] = [UIImage(named: "YO")!, UIImage(named: "HOWYOUDOING")!, UIImage(named: "WHATSUP")!, UIImage(named: "SMILEY")!, UIImage(named: "HEART")!, UIImage(named: "XOXO")!, UIImage(named: "LETSHANGOUT")!, UIImage(named: "HEY")!]
    
    var names = ["YO", "HOWYOUDOING", "WHATSUP", "SMILEY", "HEART", "XOXO", "LETSHANGOUT", "HEY"]
    
    var recipient: Contact?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

        
    @IBAction func sendButtonPressed(_ sender: AnyObject) {
        if let paths = collectionView.indexPathsForSelectedItems {
            if paths.count > 0 {
                let path = paths[0]
                let image = images[path.row]
                let name = names[path.row]
                ParseHelper.saveMessage(recipient!, image: image, controller: self, imageName: name)
            }
            else {
                self.showAlert()
            }
            
        }
        else {
            self.showAlert()
        }
    }
    
    func showAlert() {
            
        let alertController = UIAlertController(title: "No message selected", message: "Select a message before proceeding", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) {(action) in
        }
            
        alertController.addAction(okAction)
            
        self.present(alertController, animated: true, completion: nil)

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
  


extension ChooseMessageViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "messageChoice", for: indexPath) as! MessageChoiceCollectionViewCell
        cell.image = images[indexPath.row]
        return cell
    }
    

}

extension ChooseMessageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        for indexPath in collectionView.indexPathsForVisibleItems {
            collectionView.deselectItem(at: indexPath, animated: true)
            collectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor.white
        }
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.lightGray
        
    }
    
}


extension ChooseMessageViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                      didFinishWith result: MessageComposeResult) {
        // Check the result or perform other tasks.
        
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: "toCompose", sender: self)
    }
}


