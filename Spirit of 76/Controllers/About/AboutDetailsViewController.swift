//
//  AboutDetailsViewController.swift
//  Spirit of 76
//
//  Created by Tim Newton on 1/17/20.
//  Copyright © 2020 Tim W. Newton. All rights reserved.
//

import UIKit

class AboutDetailsViewController: UIViewController {
    private let libertyBell = UIImageView.init(image: UIImage.init(named: "LibertyBell"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setNavBarTitleImageToLibertyBell()
        
        if let backgroundImage = UIImage(named: "declaration_pale_blurred") {
            self.view.backgroundColor = UIColor(patternImage: backgroundImage)
        }
    }
    
    private func setNavBarTitleImageToLibertyBell() {
        self.navigationItem.titleView = libertyBell
    }
}
