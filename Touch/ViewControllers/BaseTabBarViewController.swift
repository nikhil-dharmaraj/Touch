//
//  File.swift
//  Touch
//
//  Created by Nikhil Dharmaraj on 4/1/17.
//  Copyright © 2017 Nikhil Dharmaraj. All rights reserved.
//

import Foundation
import UIKit
import ARSLineProgress

class BaseTabBarViewController: UITabBarController {
    
    var defaultIndex: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = defaultIndex
    }
    
}
