//
//  Profession+Enhancements.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 1/16/20.
//  Copyright © 2020 Tim W. Newton. All rights reserved.
//

import UIKit
import CoreData

extension Profession {
    
    //MARK:-- Card Summary
    
    override var cardTitle: String {
        return self.title ?? ""
    }
    
   override  var cardDetailText: String {
        return self.notes ?? ""
    }
    
    //MARK:-- Favorite Summary
    
    override var favoriteTitle: String {
        return self.title ?? ""
    }
    
    override var favoriteDetailText: String {
        return self.person?.fullName ?? ""
    }
    
    override var favoriteAvatar: UIImage? {
        return self.person?.favoriteAvatar
    }
}
