//
//  FavoriteDetailViewController.swift
//  Spirit of 76
//
//  Created by Tim Newton on 1/17/20.
//  Copyright © 2020 Tim W. Newton. All rights reserved.
//

import UIKit

class FavoriteDetailViewController: UIViewController {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let libertyBell = UIImageView.init(image: UIImage.init(named: "LibertyBell"))
    
    @IBOutlet weak var isFavoriteButton: UIBarButtonItem!
    
    var favorite:CardSummary?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavBarTitleImageToLibertyBell()
        
        if let backgroundImage = UIImage(named: "declaration_pale_blurred") {
            self.view.backgroundColor = UIColor(patternImage: backgroundImage)
        }
        
        refreshUI()
    }
    
    @IBAction func isFavoriteTapped(_ sender: UIBarButtonItem) {
        if var favorite = favorite {
            favorite.cardIsFavorite = !favorite.cardIsFavorite
            
            appDelegate.saveContext()
            showFavorite()
        }
    }
    
    private func showFavorite() {
        if let _ = favorite {
            //
        }
        else {
            isFavoriteButton.image = UIImage.init(systemName: "star")
            isFavoriteButton.isEnabled = false
        }
    }
    
    private func setNavBarTitleImageToLibertyBell() {
        self.navigationItem.titleView = libertyBell
    }
    
    private func refreshUI() {
        showFavorite()
    }
}
