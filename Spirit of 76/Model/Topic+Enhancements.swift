//
//  Topic+Enhancements.swift
//  Spirit of 76
//
//  Created by Tim Newton on 1/17/20.
//  Copyright © 2020 Tim W. Newton. All rights reserved.
//

import Foundation
import CoreData

extension Topic {
    
    //MARK:-- Card Summary
    
    override var cardTitle: String {
        return self.title ?? ""
    }
    
    override var cardDetailText: String {
        return self.detailText
    }
    
    //MARK:-- Favorite Summary
    
    override var favoriteTitle: String {
        return self.title ?? ""
    }
    
    override var favoriteDetailText: String {
        return self.detailText
    }
    
    var detailText: String {
        self.notes ?? self.synopsis ?? ""
    }
}
