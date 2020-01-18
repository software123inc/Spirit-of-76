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
    
    var image:UIImage? {
        get {
            if let imageName = self.imageName {
                return UIImage(named: imageName)
            }
            
            return nil
        }
    }
    
//    var portraitImage:UIImage? {
//        get {
//            let imageName = "\(self.lastName ?? "?")_\(self.firstName ?? "?")"
//            return UIImage(named: imageName)
//        }
//    }
    
    var avatar:UIImage? {
        get {
            if let imageName = self.imageName {
                return UIImage(named: "Avatars/\(imageName)")
            }
            
            return nil
        }
    }
    
    var educationCards:[CardSummary]? {
        get {
            return cards(fromSet: self.educations)
        }
    }
    
    var factCards:[CardSummary]? {
        get {
            return cards(fromSet: self.facts)
        }
    }
    
    var professionCards:[CardSummary]? {
        get {
            return cards(fromSet: self.professions)
        }
    }
    
    var quotesCards:[CardSummary]? {
        get {
            return cards(fromSet: self.quotes)
        }
    }
    
    private func cards(fromSet cardSet:NSSet?) -> [CardSummary]? {
        guard let cardSet = cardSet else { return nil }
        
        return (Array<Any>(cardSet) as? [CardSummary])?.sorted(by: { (lhs, rhs) -> Bool in
            if lhs.cardTitle == rhs.cardTitle {
                return lhs.cardDetailText < rhs.cardDetailText
            }
            
            return lhs.cardTitle < rhs.cardTitle
        })
    }
}
