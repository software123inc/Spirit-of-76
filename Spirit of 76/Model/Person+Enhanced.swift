//
//  Person+Enhanced.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 1/4/20.
//  Copyright © 2020 Tim W. Newton. All rights reserved.
//

import UIKit
import CoreData

extension Person {
    var fullName:String {
        get {
            return "\(self.firstName ?? "?")\(self.middleName != nil ? " \(self.middleName!)" : "") \(self.lastName ?? "?")"
        }
    }
    
    var lastFirst:String {
        get {
            return "\(self.lastName ?? "?") \(self.firstName ?? "?")"
        }
    }
    
    var imageName:String {
        get {
            return "\(self.lastName ?? "?")_\(self.firstName ?? "?")"
        }
    }
    
    var portraitImage:UIImage? {
        get {
            return UIImage(named: self.imageName)
        }
    }
    
    var avatar:UIImage? {
        get {
            return UIImage(named: "Avatars/\(self.imageName)")
        }
    }
    
    var educationCards:[CardSummary]? {
        get {
            if let cards = self.educations {
                return Array<Any>(cards) as? [CardSummary]
            }
            return nil
        }
    }
    
    var factCards:[CardSummary]? {
        get {
            if let cards = self.facts {
                return Array<Any>(cards) as? [CardSummary]
            }
            return nil
        }
    }
    
    var professionCards:[CardSummary]? {
        get {
            if let cards = self.professions {
                return Array<Any>(cards) as? [CardSummary]
            }
            return nil
        }
    }
    
    var quotesCards:[CardSummary]? {
        get {
            if let cards = self.quotes {
                return Array<Any>(cards) as? [CardSummary]
            }
            return nil
        }
    }
}
