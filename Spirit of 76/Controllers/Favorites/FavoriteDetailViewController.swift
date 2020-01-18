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
    private let libertyBell = UIImageView.init(image: UIImage.init(named: "LibertyBell"))
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var isFavoriteButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    
    var favorite:CardSummary?
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavBarTitleImageToLibertyBell()
        
        if let backgroundImage = UIImage(named: "declaration_pale_blurred") {
            self.view.backgroundColor = UIColor(patternImage: backgroundImage)
        }
        
        refreshUI()
    }
    
    //MARK: - IBActions
    
    @IBAction func isFavoriteTapped(_ sender: UIBarButtonItem) {
        if var favorite = favorite {
            favorite.cardIsFavorite = !favorite.cardIsFavorite
            appDelegate.saveContext()
            showFavorite()
        }
    }
    
    //MARK:- Instance methods
    private func showFavorite() {
        if let favorite = favorite {
            isFavoriteButton.image = (favorite.cardIsFavorite) ? UIImage.init(systemName: "star.fill") : UIImage.init(systemName: "star")
            isFavoriteButton.isEnabled = true
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
        if let favorite = favorite {
            titleLabel.text = favorite.cardTitle
            detailTextView.text = favorite.cardDetailText
            detailTextView.textAlignment = .natural
        }
        else {
            titleLabel.text = "Spirit of '76"
            detailTextView.text = "Find all your saved favorites here."
            detailTextView.textAlignment = .center
        }
        
        showFavorite()
    }
}
