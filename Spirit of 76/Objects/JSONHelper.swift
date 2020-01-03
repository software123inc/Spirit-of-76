//
//  JSONHelper.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 1/2/20.
//  Copyright © 2020 Tim W. Newton. All rights reserved.
//

import UIKit
import CoreData
import CocoaLumberjackSwift
import SwiftyJSON
import S123Common

struct JSONHelper {
    private typealias ImportHandler = (_ fileName:String, _ keyPath:String) -> Void
    
    private static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private static let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private static let files = Bundle.main.paths(forResourcesOfType: "json", inDirectory: nil).sorted()
    
    private static let rootDataImportHandler: ImportHandler = { filename, keyPath in
        if let f = RootFiles.init(rawValue: filename) {
            switch f {
            case .countries:
                if let json = JSONManager.importSwiftyJSON(filename) {
                    let importSuccessful = JSONManager.seedJsonResultsToCoreData(json, context: viewContext, type: Country.self)
                    DDLogDebug("keyPath: \(keyPath) Successful: \(importSuccessful)")
                    UserDefaults.standard.setValue(importSuccessful, forKeyPath: keyPath)
                }
            case .events:
                if let json = JSONManager.importSwiftyJSON(filename) {
                    let importSuccessful = JSONManager.seedJsonResultsToCoreData(json, context: viewContext, type: Event.self)
                    DDLogDebug("keyPath: \(keyPath) Successful: \(importSuccessful)")
                    UserDefaults.standard.setValue(importSuccessful, forKeyPath: keyPath)
                }
            case .states:
                if let json = JSONManager.importSwiftyJSON(filename) {
                    let importSuccessful = JSONManager.seedJsonResultsToCoreData(json, context: viewContext, type: State.self)
                    DDLogDebug("keyPath: \(keyPath) Successful: \(importSuccessful)")
                    UserDefaults.standard.setValue(importSuccessful, forKeyPath: keyPath)
                }
            case .topics:
                if let json = JSONManager.importSwiftyJSON(filename) {
                    let importSuccessful = JSONManager.seedJsonResultsToCoreData(json, context: viewContext, type: Topic.self)
                    DDLogDebug("keyPath: \(keyPath) Successful: \(importSuccessful)")
                    UserDefaults.standard.setValue(importSuccessful, forKeyPath: keyPath)
                }
            case .writings:
                if let json = JSONManager.importSwiftyJSON(filename) {
                    let importSuccessful = JSONManager.seedJsonResultsToCoreData(json, context: viewContext, type: Writing.self)
                    DDLogDebug("keyPath: \(keyPath) Successful: \(importSuccessful)")
                    UserDefaults.standard.setValue(importSuccessful, forKeyPath: keyPath)
                }
            }
        }
    }
    
    private static let tier2ImportHandler: ImportHandler = { filename, keyPath in
        if let f = Tier2Files.init(rawValue: filename) {
            switch f {
            case .cities:
                if let json = JSONManager.importSwiftyJSON(filename) {
                    let importSuccessful = JSONManager.seedJsonResultsToCoreData(json, context: viewContext, type: City.self)
                    DDLogDebug("keyPath: \(keyPath) Successful: \(importSuccessful)")
                    UserDefaults.standard.setValue(importSuccessful, forKeyPath: keyPath)
                    
                    if importSuccessful {
                        for (index, jCity):(String, JSON) in json {
                            if let jsonId = jCity["jsonId"].int16, let city = manObj(City.self, havingJsonId: jsonId) {
                                DDLogDebug("\(index): \(city.name ?? "?")")
                                
                                if let stateId = jCity["stateId"].int16, let state = manObj(State.self, havingJsonId: stateId) {
                                    DDLogDebug("\(index): \(state.name ?? "?")")
                                    city.state = state
                                }
                                else {
                                    DDLogVerbose("Can't get state for stateId '\(jCity["stateId"].stringValue)'.")
                                }
                            }
                            else {
                                DDLogVerbose("Can't get city for jsonId '\(jCity["jsonId"].stringValue)'.")
                            }
                        }
                        
                        appDelegate.saveContext()
                    }
                }
            case .signers:
                if let json = JSONManager.importSwiftyJSON(filename) {
                    let importSuccessful = JSONManager.seedJsonResultsToCoreData(json, context: viewContext, type: Person.self)
                    DDLogDebug("keyPath: \(keyPath) Successful: \(importSuccessful)")
                    UserDefaults.standard.setValue(importSuccessful, forKeyPath: keyPath)
                    
                    if importSuccessful {
                        for (index, jPerson):(String, JSON) in json {
                            if let jsonId = jPerson["jsonId"].int16, let person = manObj(Person.self, havingJsonId: jsonId) {
                                if let birthCountryId = jPerson["birthCountryId"].int16, let country = manObj(Country.self, havingJsonId: birthCountryId) {
                                    DDLogDebug("\(index): \(country.name ?? "?")")
                                    person.birthCountry = country
                                }
                                else {
                                    DDLogWarn("Can't get country for birthCountryId '\(jPerson["birthCountryId"].stringValue)'.")
                                }
                                
                                if let birthStateId = jPerson["birthStateId"].int16, let state = manObj(State.self, havingJsonId: birthStateId) {
                                    DDLogDebug("\(index): \(state.name ?? "?")")
                                    person.birthState = state
                                }
                                else {
                                    DDLogVerbose("Can't get state for birthStateId '\(jPerson["birthStateId"].stringValue)'.")
                                }
                                
                                if let residenceStateId = jPerson["residenceStateId"].int16, let state = manObj(State.self, havingJsonId: residenceStateId) {
                                    DDLogDebug("\(index): \(state.name ?? "?")")
                                    person.residenceState = state
                                }
                                else {
                                    DDLogVerbose("Can't get state for residenceStateId '\(jPerson["residenceStateId"].stringValue)'.")
                                }
                            }
                            else {
                                DDLogVerbose("Can't get person for jsonId '\(jPerson["jsonId"].stringValue)'.")
                            }
                        }
                        
                        appDelegate.saveContext()
                    }
                }
            }
        }
    }
    
    private static let tier3ImportHandler: ImportHandler = { filename, keyPath in
        if let f = Tier3Files.init(rawValue: filename) {
            switch f {
            case .signerEducation:
                if let json = JSONManager.importSwiftyJSON(filename) {
                    let importSuccessful = JSONManager.seedJsonResultsToCoreData(json, context: viewContext, type: Education.self)
                    DDLogDebug("keyPath: \(keyPath) Successful: \(importSuccessful)")
                    UserDefaults.standard.setValue(importSuccessful, forKeyPath: keyPath)
                    
                    if importSuccessful {
                        for (index, jRec):(String, JSON) in json {
                            if let jsonId = jRec["jsonId"].int16, let edu = manObj(Education.self, havingJsonId: jsonId) {
                                DDLogDebug("\(index): \(edu.title ?? "?")")
                                
                                if let signerId = jRec["signerId"].int16, let person = manObj(Person.self, havingJsonId: signerId) {
                                    DDLogDebug("\(index): \(person.lastName ?? "?")")
                                    edu.person = person
                                }
                                else {
                                    DDLogVerbose("Can't get person for signerId '\(jRec["signerId"].stringValue)'.")
                                }
                            }
                            else {
                                DDLogVerbose("Can't get education for jsonId '\(jRec["jsonId"].stringValue)'.")
                            }
                        }
                        
                        appDelegate.saveContext()
                    }
                }
            case .signerFacts:
                if let json = JSONManager.importSwiftyJSON(filename) {
                    let importSuccessful = JSONManager.seedJsonResultsToCoreData(json, context: viewContext, type: Fact.self)
                    DDLogDebug("keyPath: \(keyPath) Successful: \(importSuccessful)")
                    UserDefaults.standard.setValue(importSuccessful, forKeyPath: keyPath)
                    
                    if importSuccessful {
                        for (index, jRec):(String, JSON) in json {
                            if let jsonId = jRec["jsonId"].int16, let fact = manObj(Fact.self, havingJsonId: jsonId) {
                                DDLogDebug("\(index): \(fact.title ?? "?")")
                                
                                if let signerId = jRec["signerId"].int16, let person = manObj(Person.self, havingJsonId: signerId) {
                                    DDLogDebug("\(index): \(person.lastName ?? "?")")
                                    fact.person = person
                                }
                                else {
                                    DDLogVerbose("Can't get person for signerId '\(jRec["signerId"].stringValue)'.")
                                }
                            }
                            else {
                                DDLogVerbose("Can't get fact for jsonId '\(jRec["jsonId"].stringValue)'.")
                            }
                        }
                        
                        appDelegate.saveContext()
                    }
                }
            case .signerProfessions:
                if let json = JSONManager.importSwiftyJSON(filename) {
                    let importSuccessful = JSONManager.seedJsonResultsToCoreData(json, context: viewContext, type: Profession.self)
                    DDLogDebug("keyPath: \(keyPath) Successful: \(importSuccessful)")
                    UserDefaults.standard.setValue(importSuccessful, forKeyPath: keyPath)
                    
                    if importSuccessful {
                        for (index, jRec):(String, JSON) in json {
                            if let jsonId = jRec["jsonId"].int16, let profession = manObj(Profession.self, havingJsonId: jsonId) {
                                DDLogDebug("\(index): \(profession.title ?? "?")")
                                
                                if let signerId = jRec["signerId"].int16, let person = manObj(Person.self, havingJsonId: signerId) {
                                    DDLogDebug("\(index): \(person.lastName ?? "?")")
                                    profession.person = person
                                }
                                else {
                                    DDLogVerbose("Can't get person for signerId '\(jRec["signerId"].stringValue)'.")
                                }
                            }
                            else {
                                DDLogVerbose("Can't get profession for jsonId '\(jRec["jsonId"].stringValue)'.")
                            }
                        }
                        
                        appDelegate.saveContext()
                    }
                }
            case .signerWritings:
                if let json = JSONManager.importSwiftyJSON(filename) {
                    let importSuccessful = true
                    DDLogDebug("keyPath: \(keyPath) Successful: \(importSuccessful)")
                    UserDefaults.standard.setValue(importSuccessful, forKeyPath: keyPath)
                    
                    if importSuccessful {
                        for (index, jRec):(String, JSON) in json {
                            if let writingId = jRec["writingId"].int16, let writing = manObj(Writing.self, havingJsonId: writingId) {
                                DDLogDebug("\(index): \(writing.title ?? "?")")
                                
                                if let signerId = jRec["signerId"].int16, let person = manObj(Person.self, havingJsonId: signerId) {
                                    DDLogDebug("\(index): \(person.lastName ?? "?")")
                                    writing.persons?.adding(person)
                                }
                                else {
                                    DDLogVerbose("Can't get person for signerId '\(jRec["signerId"].stringValue)'.")
                                }
                            }
                            else {
                                DDLogVerbose("Can't get writing for jsonId '\(jRec["writingId"].stringValue)'.")
                            }
                        }
                        
                        appDelegate.saveContext()
                    }
                }
            }
        }
    }
    
    private static let tier4ImportHandler: ImportHandler = { filename, keyPath in
        if let f = Tier4Files.init(rawValue: filename) {
            switch f {
            case .quotes:
                if let json = JSONManager.importSwiftyJSON(filename) {
                    let importSuccessful = JSONManager.seedJsonResultsToCoreData(json, context: viewContext, type: Quote.self)
                    DDLogDebug("keyPath: \(keyPath) Successful: \(importSuccessful)")
                    UserDefaults.standard.setValue(importSuccessful, forKeyPath: keyPath)
                    
                    if importSuccessful {
                        for (index, jRec):(String, JSON) in json {
                            if let jsonId = jRec["jsonId"].int16, let quote = manObj(Quote.self, havingJsonId: jsonId) {
                                DDLogDebug("\(index): \(quote.quotation?.prefix(10) ?? "?")")
                                
                                if let signerId = jRec["signerId"].int16, let person = manObj(Person.self, havingJsonId: signerId) {
                                    DDLogDebug("\(index): \(person.lastName ?? "?")")
                                    quote.person = person
                                }
                                else {
                                    DDLogVerbose("Can't get person for signerId '\(jRec["signerId"].stringValue)'.")
                                }
                            }
                            else {
                                DDLogVerbose("Can't get quote for jsonId '\(jRec["jsonId"].stringValue)'.")
                            }
                        }
                        
                        appDelegate.saveContext()
                    }
                }
            }
        }
    }
    
    private static func importData(handler:ImportHandler) {
        for file in JSONHelper.files {
            let filename = file.lastPathComponenSansExtension
            let keyPath = "JSONManager_\(filename)"
            let needsImport = !UserDefaults.standard.bool(forKey: keyPath)
            
            if needsImport {
                handler(filename, keyPath)
            }
        }
    }
    
    static func importSeedData() {
        JSONHelper.importData(handler: rootDataImportHandler)
        JSONHelper.importData(handler: tier2ImportHandler)
        JSONHelper.importData(handler: tier3ImportHandler)
        JSONHelper.importData(handler: tier4ImportHandler)
    }
    
    static func manObj<T:NSManagedObject>(_ type:T.Type, havingJsonId jsonId:Int16) -> T? {
        var results:[T]?
        let request: NSFetchRequest<T> = T.fetchRequest() as! NSFetchRequest<T>
        let predicate = NSPredicate(format: "jsonId == %i", jsonId)
        
        request.predicate = predicate
        
        do {
            results = try viewContext.fetch(request)
        }
        catch {
            DDLogError(error.localizedDescription)
        }
        
        return results?.first
    }
    
    static func city(havingJsonId jsonId:Int16) -> City? {
        var results:[City]?
        let request: NSFetchRequest<City> = City.fetchRequest()
        let predicate = NSPredicate(format: "jsonId == %i", jsonId)
        
        request.predicate = predicate
        
        do {
            results = try viewContext.fetch(request)
            
            if let result = results?.first {
                return result
            }
        }
        catch {
            DDLogError(error.localizedDescription)
        }
        
        return nil
    }
}

fileprivate enum RootFiles:String {
    case
    countries,
    events,
    states,
    topics,
    writings
}

fileprivate enum Tier2Files:String {
    case cities,
    signers
}

fileprivate enum Tier3Files:String {
    case signerEducation,
    signerFacts,
    signerProfessions,
    signerWritings
}

fileprivate enum Tier4Files:String {
    case quotes
}
