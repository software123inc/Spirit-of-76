//
//  Quote+Enhancements.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 1/16/20.
//  Copyright © 2020 Tim W. Newton. All rights reserved.
//

import Foundation
import CoreData

extension Quote: CardSummary {
    var cardTitle: String {
        if let prefix = self.quotation?.prefix(19) {
            return "\(prefix)…"
        }
        return " "
    }
    
    var cardDetailText: String {
        return self.quotation ?? "<No Detail Text>"
    }
    
    var cardIsFavorite: Bool {
        get {
            return self.isFavorite
        }
        
        set {
            self.isFavorite = newValue
        }
    }
}
