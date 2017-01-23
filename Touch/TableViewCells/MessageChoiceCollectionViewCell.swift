//
//  MessageChoiceCollectionViewCell.swift
//  Touch
//
//  Created by Nikhil Dharmaraj on 7/21/16.
//  Copyright © 2016 Nikhil Dharmaraj. All rights reserved.
//

import UIKit

class MessageChoiceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage? {
        didSet {
            if let image = image {
                imageView.image = image
            }
        }
    }
    
}
