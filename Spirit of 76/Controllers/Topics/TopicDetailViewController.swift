//
//  TopicDetailViewController.swift
//  Spirit of 76
//
//  Created by Tim Newton on 1/17/20.
//  Copyright © 2020 Tim W. Newton. All rights reserved.
//

import UIKit

class TopicDetailViewController: UIViewController {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let libertyBell = UIImageView.init(image: UIImage.init(named: "LibertyBell"))
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var isFavoriteButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    
    var topic:Topic?

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
        if let topic = topic {
            topic.isFavorite = !topic.isFavorite
            
            appDelegate.saveContext()
            showFavorite()
        }
    }
    
    private func setNavBarTitleImageToLibertyBell() {
        self.navigationItem.titleView = libertyBell
    }
    
    private func showFavorite() {
        if let topic = topic {
            isFavoriteButton.image = (topic.cardIsFavorite) ? UIImage.init(systemName: "star.fill") : UIImage.init(systemName: "star")
            isFavoriteButton.isEnabled = true
        }
        else {
            isFavoriteButton.image = UIImage.init(systemName: "star")
            isFavoriteButton.isEnabled = false
        }
    }
    
    private func refreshUI() {
        if let topic = topic {
            titleLabel.text = topic.cardTitle
            detailTextView.text = topic.cardDetailText
            detailTextView.textAlignment = .natural
        }
        else {
            titleLabel.text = "Spirit of '76"
            detailTextView.text = "Learn about many notable topics of America's War for Independence."
            detailTextView.textAlignment = .center
        }
        
        showFavorite()
    }
}
