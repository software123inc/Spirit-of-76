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
    override var cardTitle: String {
        return self.title ?? ""
    }
    
    override var cardDetailText: String {
        return self.notes ?? self.synopsis ?? ""
    }
}
