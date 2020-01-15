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
    @IBOutlet weak var educationContainerView: UIView!
    @IBOutlet weak var educationContainerHeightConstraint: NSLayoutConstraint!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.delegate = self
        
        // Do any additional setup after loading the view.
        if let backgroundImage = UIImage(named: "declaration_pale_blurred") {
            self.view.backgroundColor = UIColor(patternImage: backgroundImage)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        refreshUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavBarTitleImageToLibertyBell()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        DDLogDebug("prepare segue '\(String(describing: segue.identifier))'.")
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
    
    fileprivate func hideEducationContainerView() {
        educationContainerHeightConstraint.constant = 0
    }
}

extension PersonDetailViewController: PersonSelectionDelegate {
    func personSelected(_ newPerson: Person) {
        self.person = newPerson
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
