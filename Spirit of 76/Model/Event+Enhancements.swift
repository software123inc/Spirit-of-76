//
//  Event+Enhancements.swift
//  Spirit of 76
//
//  Created by Tim Newton on 1/17/20.
//  Copyright © 2020 Tim W. Newton. All rights reserved.
//

import UIKit
import CoreData

extension Event: CardSummary {
    var cardTitle: String {
        return self.name ?? "<No Title>"
    }
    
    var cardDetailText: String {
        return self.notes ?? "<No Detail Text>"
    }
    
    var cardIsFavorite: Bool {
        get {
            return self.isFavorite
        }
        
        set {
            self.isFavorite = newValue
        }
    }
    
    var cardImage: UIImage?  {
        if let imageName = self.img_portrait {
            return UIImage.init(named: imageName)
        }
        
        return nil
    }
}
