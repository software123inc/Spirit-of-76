//
//  Quote+Enhancements.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 1/16/20.
//  Copyright © 2020 Tim W. Newton. All rights reserved.
//

import UIKit
import CoreData

extension Quote {
    
    //MARK:-- Card Summary
    
    override var cardTitle: String {
        return shortQuote
    }
    
    override var cardDetailText: String {
        return self.quotation ?? ""
    }
    
    //MARK:-- Favorite Summary
    
    override var favoriteTitle: String {
        return shortQuote
    }
    
    override var favoriteDetailText: String {
        return self.person?.fullName ?? ""
    }
    
    var shortQuote: String {
        if let prefix = self.quotation?.prefix(19) {
            return "\(prefix)…"
        }
        return ""
    }
    
    override var favoriteAvatar: UIImage? {
        return self.person?.favoriteAvatar
    }
}
