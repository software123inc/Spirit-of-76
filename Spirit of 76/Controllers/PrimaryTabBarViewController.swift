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
        configureInitialViewController()
    }
    
    private func configureInitialViewController() {
        if let svc = self.viewControllers?.first as? UISplitViewController {
            DDLogVerbose("Found the split view!!")
            if let masterNavVC = svc.viewControllers.first as? UINavigationController {
                DDLogVerbose("Found the master Nav view!!")
                
                if let masterVc = masterNavVC.topViewController as? PersonsTableViewController {
                    DDLogVerbose("Found the master view!!")

                    if let detailVC = svc.viewControllers[1] as? PersonDetailViewController {
                        DDLogVerbose("Found the detail view!!")
                        masterVc.delegate = detailVC
                    }
                }
            }
        }
    }
}

extension PrimaryTabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        DDLogVerbose("Selected view controller '\(viewController.className)'.")
    }
}