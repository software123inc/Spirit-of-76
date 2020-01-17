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
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let horizontalSizeClass = UIScreen.main.traitCollection.horizontalSizeClass
    let signersStoryboard = UIStoryboard.init(name: "Signers", bundle: nil)
    var cardSummaries: [CardSummary]?
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        for cardSummary in cardSummaries {
            let cardSummaryVC = appendCardSummaryViewController()
            
            cardSummaryVC?.cardSummary = cardSummary
            cardSummaryVC?.titleLabel.text = cardSummary.cardTitle
            cardSummaryVC?.detailTextView.text = cardSummary.cardDetailText
        }
        
        if horizontalSizeClass == .regular {
            let fillerSize = 3 - (cardSummaries.count % 3)
            
            for _ in 1...fillerSize {
                let cardSummaryVC = appendCardSummaryViewController()
                makeCardSummaryInvisible(cardSummaryVC)
            }
        }
    }
    
    private func makeCardSummaryInvisible(_ cardSummaryVC:CardSummaryContentViewController?) {
        cardSummaryVC?.view?.backgroundColor = .clear
        cardSummaryVC?.titleLabel.text = ""
        cardSummaryVC?.titleLabel.backgroundColor = .clear
        cardSummaryVC?.detailTextView.text = ""
        cardSummaryVC?.detailTextView.backgroundColor = .clear
    }
    
    private func appendCardSummaryViewController() -> CardSummaryContentViewController?  {
        guard let cardSummaryVC = signersStoryboard.instantiateViewController(identifier: K.ViewControllerID.cardSummaryContent) as? CardSummaryContentViewController else { return nil }
        
        self.addChild(cardSummaryVC)
        cardSummaryVC.view.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.addArrangedSubview(cardSummaryVC.view)
        self.stackView.addSubview(cardSummaryVC.view)
        
        switch(horizontalSizeClass) {
            case .compact:
                pageControl.numberOfPages = cardSummaries?.count ?? 0
                NSLayoutConstraint.activate([
                    cardSummaryVC.view.widthAnchor.constraint(equalToConstant: view.frame.width),
                    cardSummaryVC.view.heightAnchor.constraint(equalToConstant: 180)
                ])
            default:
                DDLogVerbose("iPad page count = \(Int((cardSummaries?.count ?? 0) / 3) + 1)")
                pageControl.numberOfPages = Int((cardSummaries?.count ?? 0) / 3) + 1
                NSLayoutConstraint.activate([
                    cardSummaryVC.view.widthAnchor.constraint(equalToConstant: view.frame.width / 3),
                    cardSummaryVC.view.heightAnchor.constraint(equalToConstant: 180)
                ])
        }
        
        cardSummaryVC.didMove(toParent: self)
        
        return cardSummaryVC
    }
    
    private func removeViewFromStack(_ unwantedView:UIView) {
        stackView.removeArrangedSubview(unwantedView)
        unwantedView.removeFromSuperview()
    }
}

extension CardSummaryStackViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.bounds.width
        pageControl.currentPage = Int(scrollView.contentOffset.x / pageWidth)
    }
}
