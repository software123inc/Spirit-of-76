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
    
    var person:Person? {
        didSet {
          refreshUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let backgroundImage = UIImage(named: "declaration_pale_blurred") {
            self.view.backgroundColor = UIColor(patternImage: backgroundImage)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        refreshUI()
    }
    
    func refreshUI() {
        loadViewIfNeeded()
        
        if let person = person {
            self.personFullNameLabel.text = person.fullName
            self.personImageView.image = person.portraitImage
            self.personDescriptionTextView.text = person.descriptiveText
            self.residentStateImageView.image = person.residenceState?.blueImage
        }
        else {
            self.personFullNameLabel.text = "Spirit of '76"
            self.personImageView.image = UIImage(named: "Fife_and_Drum")
            self.personDescriptionTextView.text = "Learn about the Signers of the Declaration of Independence."
        }
    }
}

extension PersonDetailViewController: PersonSelectionDelegate {
    func personSelected(_ newPerson: Person) {
        self.person = newPerson
    }
}
