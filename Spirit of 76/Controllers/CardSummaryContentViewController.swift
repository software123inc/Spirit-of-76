//
//  CardSummaryContentViewController.swift
//  Spirit of 76
//
//  Created by Tim Newton on 1/14/20.
//  Copyright © 2020 Tim W. Newton. All rights reserved.
//

import UIKit
import CoreData
import CocoaLumberjackSwift

class CardSummaryContentViewController: UIViewController {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var isFavoriteButton: UIButton?
    @IBOutlet weak var isFavoriteButtonTrailingConstraint: NSLayoutConstraint!
    
    var cardSummary:CardSummary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showFavorite()

        // Do any additional setup after loading the view.
        titleLabel.text = cardSummary?.cardTitle
        detailTextView.text = cardSummary?.cardDetailText
        
        detailTextView.isScrollEnabled = UserDefaults.standard.bool(forKey: K.PrefKey.scrollMiniTextViews)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.SegueID.moreDetailTextPopover, let dvc = segue.destination as? CardSummaryContentViewController {
            dvc.cardSummary = cardSummary
        }
        else {
            DDLogDebug("Unhandled segue ID '\(segue.identifier ?? "unknown identifier")'")
        }
    }
    
    //MARK:- IBActions
    @IBAction func isFavoriteTapped(_ sender: UIButton) {
        if var cardSummary = cardSummary {
            cardSummary.cardIsFavorite = !cardSummary.cardIsFavorite
            
            appDelegate.saveContext()
            NotificationCenter.default.post(name: Notification.Name.didToggleFavorite, object: cardSummary)
        }
        
        showFavorite()
    }
    
    @IBAction func gestureHandler(_ sender: UIGestureRecognizer) {
        performSegue(withIdentifier: K.SegueID.moreDetailTextPopover, sender: cardSummary)
    }
    
    private func showFavorite() {
        guard  let isFavoriteButton = self.isFavoriteButton else {
            return
        }
        
        if let cardSummary = cardSummary {
            isFavoriteButton.isSelected = cardSummary.cardIsFavorite
        }
        else {
            isFavoriteButton.isEnabled = false
        }
    }
}
