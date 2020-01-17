//
//  CardSummaryContentViewController.swift
//  Spirit of 76
//
//  Created by Tim Newton on 1/14/20.
//  Copyright © 2020 Tim W. Newton. All rights reserved.
//

import UIKit
import CocoaLumberjackSwift

class CardSummaryContentViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    
    var cardSummary:CardSummary?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel.text = cardSummary?.cardTitle
        detailTextView.text = cardSummary?.cardDetailText
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.SegueID.moreDetailTextPopover, let dvc = segue.destination as? CardSummaryContentViewController {
            dvc.cardSummary = cardSummary
        }
        else {
            DDLogDebug("Unhandled segue ID '\(segue.identifier ?? "unknown identifier")'")
        }
    }
}
