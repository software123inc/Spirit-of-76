//
//  PersonDetailViewController.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 1/3/20.
//  Copyright © 2020 Tim W. Newton. All rights reserved.
//

import UIKit
import CocoaLumberjackSwift

class PersonDetailViewController: UIViewController {
    
    @IBOutlet weak var personFullNameLabel: UILabel!
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var residentStateImageView: UIImageView!
    @IBOutlet weak var personDescriptionTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleViewLabel: UILabel?
    //    @IBOutlet weak var educationContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var educationViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var educationView: UIView!
    
    weak var educationViewController:CardSummaryStackViewController?
    
    let titleViewImageFrame = CGRect.init(x: 0, y: 0, width: 23.5, height: 30)
    var personTitleImageView:UIImageView?
    let libertyBell = UIImageView.init(image: UIImage.init(named: "LibertyBell"))
    
    var isScrolled:Bool {
        return self.scrollView.convert(self.personImageView.frame.origin, to: self.view).y < 60
    }
    
    var person:Person? {
        didSet {
            refreshUI()
        }
    }
    
    //MARK: - View Life Cycle
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.SegueID.showEducation, let dvc = segue.destination as? CardSummaryStackViewController {
            self.educationViewController = dvc
        }
        else {
            DDLogWarn("Unhandled segue id '\(String(describing: segue.identifier))'.")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.delegate = self
        
        // Do any additional setup after loading the view.
        if let backgroundImage = UIImage(named: "declaration_pale_blurred") {
            self.view.backgroundColor = UIColor(patternImage: backgroundImage)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavBarTitleImageToLibertyBell()
        
        if let dvc = self.educationViewController, let educationCards = person?.educationCards, educationCards.count > 0 {
            populateCardViewStack(dvc, summaries: educationCards)
        }
        else {
            hideEducationView()
        }
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        refreshUI()
    }
    
    private func populateCardViewStack(_ viewController:CardSummaryStackViewController, summaries:[CardSummary]) {
        DDLogVerbose("Sending \(summaries.count) card summaries.")
        viewController.cardSummaries = summaries
    }
    
    private func refreshUI() {
        loadViewIfNeeded()
        
        if let person = person {
            let fullName = person.fullName
            self.personFullNameLabel.text = fullName
            self.personImageView.image = person.portraitImage
            self.personDescriptionTextView.text = person.descriptiveText
            self.residentStateImageView.image = person.residenceState?.blueImage
        }
        else {
            let fullName = "Spirit of '76"
            self.personFullNameLabel.text = fullName
            self.personImageView.image = UIImage(named: "Fife_and_Drum")
            self.personDescriptionTextView.text = "Learn about the Signers of the Declaration of Independence."
        }
    }
    
    fileprivate func setNavBarTitleImageToLibertyBell() {
        self.navigationItem.titleView = UIView.init(frame: titleViewImageFrame)
        self.navigationItem.titleView?.addSubview(libertyBell)
        
        if let person = person  {
            personTitleImageView = UIImageView.init(image: person.avatar)
            
            if let personImageView = personTitleImageView {
                personImageView.frame = libertyBell.frame
                personImageView.contentMode = .scaleAspectFill
                self.navigationItem.titleView?.addSubview(personImageView)
            }
        }
        
        personTitleImageView?.alpha = isScrolled ? 1 : 0
        libertyBell.alpha = isScrolled ? 0 : 1
    }
    
    fileprivate func hideEducationView() {
        educationViewHeightConstraint.constant = 0
        
        for view in educationView.subviews {
            view.removeFromSuperview()
        }
    }
}

extension PersonDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.personTitleImageView != nil {
            if isScrolled {
                UIView.animate(withDuration: 0.75) {
                    self.libertyBell.alpha = 0
                    self.personTitleImageView?.alpha = 1
                }
            }
            else {
                UIView.animate(withDuration: 0.75) {
                    self.libertyBell.alpha = 1
                    self.personTitleImageView?.alpha = 0
                }
            }
        }
    }
}
