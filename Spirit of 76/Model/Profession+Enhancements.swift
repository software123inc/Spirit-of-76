//
//  Profession+Enhancements.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 1/16/20.
//  Copyright © 2020 Tim W. Newton. All rights reserved.
//

import Foundation
import CoreData

extension Profession: CardSummary {
    var cardTitle: String {
        return self.title ?? "<No Title>"
    }
    
    var cardDetailText: String {
        return self.notes ?? "<No Detail Text>"
    }
}
