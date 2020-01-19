//
//  PrimaryTabBarViewController.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 1/4/20.
//  Copyright © 2020 Tim W. Newton. All rights reserved.
//

import UIKit
import S123Common
import CocoaLumberjackSwift

class PrimaryTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get{
            
            if self.traitCollection.horizontalSizeClass == .compact {
                return .portrait
            }
            
            return .all
        }
    }
}

extension PrimaryTabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        DDLogVerbose("Selected view controller '\(viewController.className)'.")
    }
}
