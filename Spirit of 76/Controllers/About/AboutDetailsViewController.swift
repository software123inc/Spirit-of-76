//
//  AboutDetailsViewController.swift
//  Spirit of 76
//
//  Created by Tim Newton on 1/17/20.
//  Copyright © 2020 Tim W. Newton. All rights reserved.
//

import UIKit

class AboutDetailsViewController: UIViewController {
    private let libertyBell = K.ImageView.libertyBell
    
    @IBOutlet private weak var aboutTitleLabel: UILabel!
    @IBOutlet private weak var aboutImageView: UIImageView!
    @IBOutlet private weak var aboutTextView: UITextView!
    
    var aboutText:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setNavBarTitleImageToLibertyBell()
        
        self.aboutTextView.text = aboutText
        
        if let backgroundImage = K.Image.declarationBlurredBkgnd {
            self.view.backgroundColor = UIColor(patternImage: backgroundImage)
        }
    }
    
    private func setNavBarTitleImageToLibertyBell() {
        self.navigationItem.titleView = libertyBell
    }
}
