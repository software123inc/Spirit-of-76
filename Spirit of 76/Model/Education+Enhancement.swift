//
//  Education+Enhancement.swift
//  Spirit of 76
//
//  Created by Tim Newton on 1/14/20.
//  Copyright © 2020 Tim W. Newton. All rights reserved.
//

import UIKit
import CoreData

extension Education {
    
    //MARK:-- Card Summary
    
    override var cardTitle: String {
        return self.title ?? ""
    }
    
    override var cardDetailText: String {
        return self.notes ?? ""
    }
    
    //MARK:-- Favorite Summary
    
    override var favoriteTitle: String {
        return self.title ?? ""
    }
    
    override var favoriteDetailText: String {
        if let person = person, let notes = self.notes {
            return "(\(person.fullName)) \(notes)"
        }
        else {
            return ""
        }
    }
    
    override var favoriteAvatar: UIImage? {
        return self.person?.favoriteAvatar
    }
}
