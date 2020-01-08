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
    
    @IBOutlet weak var personFullName: UILabel!
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var personDescriptionLabel: UILabel!
    
    var person:Person? {
        didSet {
          refreshUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let backgroundImage = UIImage(named: "declaration_pale_blurred")?.cgImage {
            view.layer.contents = backgroundImage
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        refreshUI()
    }
    
    func refreshUI() {
        loadViewIfNeeded()
        
        self.personFullName.text = person?.fullName
        self.personImageView.image = person?.portraitImage
        self.personDescriptionLabel.text = person?.descriptiveText
    }
}

extension PersonDetailViewController: PersonSelectionDelegate {
    func personSelected(_ newPerson: Person) {
        self.person = newPerson
    }
}
