//
//  JsonImport+Enhancements.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 1/17/20.
//  Copyright © 2020 Tim W. Newton. All rights reserved.
//

import CoreData
import UIKit

extension JsonImport: CardSummary {
    @objc var cardTitle: String {
        return ""
    }
    
    @objc var cardDetailText: String {
        return ""
    }
    
    @objc var cardIsFavorite: Bool {
        get {
            return self.isFavorite
        }
        
        set {
            self.isFavorite = newValue
        }
    }
    
    @objc var cardImage: UIImage?  {
        if let imageName = self.imageName {
            return UIImage.init(named: imageName)
        }
        
        return nil
    }
}
