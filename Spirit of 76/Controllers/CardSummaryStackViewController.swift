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
    var isTransition = false
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        populateStackView()
    }
    
    //MARK: - IBAction Management
    
    @IBAction func pageControlValueChanged(_ sender: UIPageControl) {
        DDLogVerbose("Need scrolling update to page \(sender.currentPage - 1)!")
        
        let scrollToX = Int(self.scrollView.frame.size.width) * sender.currentPage
        let scrollToY = 0
        let width = Int(self.scrollView.frame.size.width)
        let height = Int(self.scrollView.frame.size.height)
        
        let visibleRect = CGRect(x: scrollToX, y: scrollToY, width: width, height: height)
        
        self.scrollView.scrollRectToVisible(visibleRect, animated: true)
    }
    
    //MARK: - Data Management
    
    private func populateStackView() {
        DDLogVerbose("Populating stack view.")
        
        guard let cardSummaries = cardSummaries, cardSummaries.count > 0 else {
            DDLogWarn("Can't populate stack view yet with \(self.cardSummaries?.count ?? -1) cards.")
            return
        }
        
        for subview in stackView.subviews {
            removeViewFromStack(subview)
        }
        
        for cardSummary in cardSummaries {
            let cardSummaryVC = appendCardSummaryViewController()
            
            cardSummaryVC?.cardSummary = cardSummary
            cardSummaryVC?.titleLabel.text = cardSummary.cardTitle
            cardSummaryVC?.detailTextView.text = cardSummary.cardDetailText
        }
        
        if horizontalSizeClass == .regular {
            let fillerSize = 3 - (cardSummaries.count % 3)
            
            if fillerSize < 3 {
                for _ in 1...fillerSize {
                    let cardSummaryVC = appendCardSummaryViewController()
                    makeCardSummaryInvisible(cardSummaryVC)
                }
            }
        }
        
        updatePageCount()
    }
    
    private func updatePageCount() {
        guard let cardSummaries = cardSummaries else { return }
        
        switch(horizontalSizeClass) {
            case .compact:
                pageControl.numberOfPages = cardSummaries.count
            default:
                DDLogVerbose("iPad page count = \(Int(cardSummaries.count / 3) + 1)")
                pageControl.numberOfPages = Int(cardSummaries.count / 3) + min(1, cardSummaries.count % 3)
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
        DDLogVerbose("In stack view: \(stackView.subviews.count), Summaries: \(cardSummaries?.count ?? -99)")
        guard let cardSummaryVC = signersStoryboard.instantiateViewController(identifier: K.ViewControllerID.cardSummaryContent) as? CardSummaryContentViewController else { return nil }
        
        self.addChild(cardSummaryVC)
        cardSummaryVC.view.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.addArrangedSubview(cardSummaryVC.view)
        self.stackView.addSubview(cardSummaryVC.view)
        
        switch(horizontalSizeClass) {
            case .compact:
                NSLayoutConstraint.activate([
                    cardSummaryVC.view.widthAnchor.constraint(equalToConstant: view.frame.width),
                    cardSummaryVC.view.heightAnchor.constraint(equalToConstant: 180)
                ])
            default:
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
