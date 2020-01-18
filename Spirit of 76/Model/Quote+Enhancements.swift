//
//  Quote+Enhancements.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 1/16/20.
//  Copyright © 2020 Tim W. Newton. All rights reserved.
//

import Foundation
import CoreData

extension Quote {
    override var cardTitle: String {
        if let prefix = self.quotation?.prefix(19) {
            return "\(prefix)…"
        }
        return " "
    }
    
    override var cardDetailText: String {
        return self.quotation ?? ""
    }
}
