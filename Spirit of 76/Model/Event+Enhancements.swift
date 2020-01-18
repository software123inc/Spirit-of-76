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
    override var cardTitle: String {
        return self.name ?? "<No Title>"
    }
    
    override var cardDetailText: String {
        return self.notes ?? "<No Detail Text>"
    }
}
