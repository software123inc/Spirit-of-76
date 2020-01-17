//
//  Education+Enhancement.swift
//  Spirit of 76
//
//  Created by Tim Newton on 1/14/20.
//  Copyright © 2020 Tim W. Newton. All rights reserved.
//

import Foundation
import CoreData

extension Education: CardSummary {
    var cardTitle: String {
        return self.title ?? "<No Title>"
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
}
