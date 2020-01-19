//
//  FavoriteDetailViewController.swift
//  Spirit of 76
//
//  Created by Tim Newton on 1/17/20.
//  Copyright © 2020 Tim W. Newton. All rights reserved.
//

import UIKit
import CoreData
import CocoaLumberjackSwift

class FavoriteDetailViewController: UIViewController {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let libertyBell = K.ImageView.libertyBell
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var isFavoriteButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    
    var favorite:FavoriteSummary?
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavBarTitleImageToLibertyBell()
        
        if let backgroundImage = K.Image.declarationBlurredBkgnd {
            self.view.backgroundColor = UIColor(patternImage: backgroundImage)
        }
        
        refreshUI()
    }
    
    //MARK: - IBActions
    
    @IBAction func isFavoriteTapped(_ sender: UIBarButtonItem) {
        if var favorite = favorite {
            favorite.itemIsFavorite = !favorite.itemIsFavorite
            appDelegate.saveContext()
            showFavorite()
            NotificationCenter.default.post(name: Notification.Name.didToggleFavorite, object: favorite)
        }
    }
    
    //MARK:- Instance methods
    private func showFavorite() {
        if let favorite = favorite {
            isFavoriteButton.image = (favorite.itemIsFavorite) ? K.Image.star_filled : K.Image.star
            isFavoriteButton.isEnabled = true
        }
        else {
            isFavoriteButton.image = K.Image.star
            isFavoriteButton.isEnabled = false
        }
    }
    
    private func setNavBarTitleImageToLibertyBell() {
        self.navigationItem.titleView = libertyBell
    }
    
    private func refreshUI() {
        if let favorite = favorite {
            titleLabel.text = favorite.favoriteTitle
            detailTextView.text = favorite.favoriteDetailText
            detailTextView.textAlignment = .natural
            imageView.image = favorite.favoriteImage
        }
        else {
            titleLabel.text = K.appName
            detailTextView.text = "Find all your saved favorites here."
            detailTextView.textAlignment = .center
            imageView.image = K.Image.fife_and_drum
        }
        
        showFavorite()
    }
}
