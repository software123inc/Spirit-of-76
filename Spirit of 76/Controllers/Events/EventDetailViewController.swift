//
//  EventDetailViewController.swift
//  Spirit of 76
//
//  Created by Tim Newton on 1/17/20.
//  Copyright © 2020 Tim W. Newton. All rights reserved.
//

import UIKit
import CocoaLumberjackSwift

class EventDetailViewController: UIViewController {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let libertyBell = K.ImageView.libertyBell
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var isFavoriteButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    
    var event:Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setNavBarTitleImageToLibertyBell()
        
        if let backgroundImage = K.Image.declarationBlurredBkgnd {
            self.view.backgroundColor = UIColor(patternImage: backgroundImage)
        }
        
        refreshUI()
    }
    
    @IBAction func isFavoriteTapped(_ sender: UIBarButtonItem) {
        if let event = event {
            event.isFavorite = !event.isFavorite
            
            appDelegate.saveContext()
            showFavorite()
        }
    }
    
    private func setNavBarTitleImageToLibertyBell() {
        self.navigationItem.titleView = libertyBell
    }
    
    private func showFavorite() {
        if let event = event {
            isFavoriteButton.image = (event.cardIsFavorite) ? K.Image.star_filled : K.Image.star
            isFavoriteButton.isEnabled = true
        }
        else {
            isFavoriteButton.image = K.Image.star
            isFavoriteButton.isEnabled = false
        }
    }
    
    private func refreshUI() {
        if let event = event {
            titleLabel.text = event.cardTitle
            detailTextView.text = event.cardDetailText
            imageView.image = event.cardImage
            detailTextView.textAlignment = .natural
        }
        else {
            titleLabel.text = K.appName
            detailTextView.text = "Learn about many notable events of America's War for Independence."
            imageView.image = K.Image.fife_and_drum
            detailTextView.textAlignment = .center
        }
        
        showFavorite()
    }
}
