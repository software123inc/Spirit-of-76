//
//  PrimarySplitViewController.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 1/3/20.
//  Copyright © 2020 Tim W. Newton. All rights reserved.
//

import UIKit
import CocoaLumberjackSwift

class PrimarySplitViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.delegate = self
        self.preferredDisplayMode = .primaryOverlay
    }
}

extension PrimarySplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        // Return true to initally show Master (primary) view controller.
        // Return false to initally show Detail (secondary) view controller.
        
        let shouldCollapse = UserDefaults.standard.bool(forKey: K.PrefKey.showTablesInitially)
        DDLogVerbose("shouldCollapse: \(shouldCollapse)")
        
        return shouldCollapse
    }
}
