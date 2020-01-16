//
//  CardSummaryStackViewController.swift
//  Spirit of 76
//
//  Created by Tim Newton on 1/14/20.
//  Copyright © 2020 Tim W. Newton. All rights reserved.
//

import UIKit
import S123Common
import CocoaLumberjackSwift

class CardSummaryStackViewController: UIViewController {
    @IBOutlet weak var stackView: UIStackView!
    
    let signersStoryboard = UIStoryboard.init(name: "Signers", bundle: nil)
    var cardSummaries: [CardSummary]?
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.SegueID.addCardSummaryContent {
            DDLogVerbose("Add dvc for \(segue.destination.className)")
        }
        else {
            DDLogWarn("Unhandled Segue ID: \(segue.identifier ?? "Unidentified segue.")")
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        populateStackView()
    }
    
    //MARK: - Data Management
    
    private func populateStackView() {
        guard let cardSummaries = cardSummaries, cardSummaries.count > 0, let firstSubview = stackView.arrangedSubviews.first else {
            DDLogWarn("Can't populate stack view yet with \(self.cardSummaries?.count ?? -1) cards.")
            return
        }
        
        removeViewFromStack(firstSubview)
        
        DDLogVerbose("I have \(cardSummaries.count) EDU records.")
        
        for summary in cardSummaries {
            let cardSummaryVC = appendCardSummaryViewController()
            cardSummaryVC?.titleLabel.text = summary.cardTitle
            cardSummaryVC?.detailTextView.text = summary.cardDetailText
        }
    }
    
    private func appendCardSummaryViewController() -> CardSummaryContentViewController?  {
        guard let cardSummaryVC = signersStoryboard.instantiateViewController(identifier: "CardSummaryContent") as? CardSummaryContentViewController else { return nil }
        
        self.addChild(cardSummaryVC)
        cardSummaryVC.view.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.addArrangedSubview(cardSummaryVC.view)
        self.stackView.addSubview(cardSummaryVC.view)
        
        NSLayoutConstraint.activate([
            cardSummaryVC.view.widthAnchor.constraint(equalToConstant: 350),
            cardSummaryVC.view.heightAnchor.constraint(equalToConstant: 180)
        ])
        
        cardSummaryVC.didMove(toParent: self)
        
        return cardSummaryVC
    }
    
    private func removeViewFromStack(_ unwantedView:UIView) {
        stackView.removeArrangedSubview(unwantedView)
        unwantedView.removeFromSuperview()
    }
}
