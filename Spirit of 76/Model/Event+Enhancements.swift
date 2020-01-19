//
//  Event+Enhancements.swift
//  Spirit of 76
//
//  Created by Tim Newton on 1/17/20.
//  Copyright © 2020 Tim W. Newton. All rights reserved.
//

import UIKit
import CoreData

extension Event {
    
    //MARK:-- Card Summary
    
    override var cardTitle: String {
        return self.name ?? ""
    }
    
    override var cardDetailText: String {
        return self.notes ?? ""
    }
    
    //MARK:-- Favorite Summary
    
    override var favoriteTitle: String {
        return self.name ?? ""
    }
    
    override var favoriteDetailText: String {
        return self.notes ?? ""
    }
}
