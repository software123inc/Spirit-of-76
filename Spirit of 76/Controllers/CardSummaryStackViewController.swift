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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appendCardSummaryViewController()
        
        // Do any additional setup after loading the view.
        if stackView.arrangedSubviews.count > 0, let lastSubview = stackView.arrangedSubviews.last, let firstSubview = stackView.arrangedSubviews.first {
            DDLogDebug("Multple subviews: \(stackView.arrangedSubviews.count), remove view \(lastSubview.className), first: \(firstSubview.className)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        DDLogInfo("Segue Identifier: \(segue.identifier ?? "Unidentified segue.")")
    }
    
    fileprivate func appendCardSummaryViewController() {
        if let cardSummaryVC = signersStoryboard.instantiateViewController(identifier: "CardSummaryContent") as? CardSummaryContentViewController {
            DDLogDebug("CardSummaryContent: \(cardSummaryVC.className)")
            
            self.addChild(cardSummaryVC)
            cardSummaryVC.view.translatesAutoresizingMaskIntoConstraints = false
            self.stackView.addArrangedSubview(cardSummaryVC.view)
            self.stackView.addSubview(cardSummaryVC.view)
            
            NSLayoutConstraint.activate([
                cardSummaryVC.view.widthAnchor.constraint(equalToConstant: 350),
                cardSummaryVC.view.heightAnchor.constraint(equalToConstant: 180)
            ])
            
            cardSummaryVC.didMove(toParent: self)
            cardSummaryVC.titleLabel.text = "I'm a new creation"
        }
    }
    
    fileprivate func removeViewFromStack(_ unwantedView:UIView) {
        stackView.removeArrangedSubview(unwantedView)
        unwantedView.removeFromSuperview()
    }
}
