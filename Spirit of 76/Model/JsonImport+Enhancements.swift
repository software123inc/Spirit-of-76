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
    @objc
    var cardTitle: String {
        return ""
    }
    
    @objc
    var cardDetailText: String {
        return ""
    }
    
    @objc
    var cardIsFavorite: Bool {
        get {
            return self.isFavorite
        }
        
        set {
            self.isFavorite = newValue
        }
    }
    
    @objc
    var cardImage: UIImage?  {
        if let imageName = self.imageName {
            return UIImage.init(named: imageName)
        }
        
        return nil
    }
}

extension JsonImport: FavoriteSummary {
    @objc
    var itemIsFavorite: Bool {
        get {
            return self.isFavorite
        }
        
        set {
            self.isFavorite = newValue
        }
    }
    
    @objc
    var favoriteTitle: String {
        return ""
    }
    
    @objc
    var favoriteDetailText: String {
        return ""
    }
    
    @objc
    var favoriteImage: UIImage? {
        if let imageName = self.imageName {
            return UIImage.init(named: imageName)
        }
        
        return nil
    }
    
    @objc
    var favoriteAvatar: UIImage? {
        if let imageName = self.imageName {
            return UIImage.init(named: "Avatars/\(imageName)")
        }
        
        return nil
    }
}
