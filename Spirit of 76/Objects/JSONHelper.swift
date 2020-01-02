//
//  JSONHelper.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 1/2/20.
//  Copyright © 2020 Tim W. Newton. All rights reserved.
//

import UIKit
import CocoaLumberjackSwift
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
                }
            case .signers:
                if let json = JSONManager.importSwiftyJSON(filename) {
                    let importSuccessful = JSONManager.seedJsonResultsToCoreData(json, context: viewContext, type: Person.self)
                    DDLogDebug("keyPath: \(keyPath) Successful: \(importSuccessful)")
                    UserDefaults.standard.setValue(importSuccessful, forKeyPath: keyPath)
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
                }
            case .signerFacts:
                if let json = JSONManager.importSwiftyJSON(filename) {
                    let importSuccessful = JSONManager.seedJsonResultsToCoreData(json, context: viewContext, type: Fact.self)
                    DDLogDebug("keyPath: \(keyPath) Successful: \(importSuccessful)")
                    UserDefaults.standard.setValue(importSuccessful, forKeyPath: keyPath)
                }
            case .signerProfessions:
                if let json = JSONManager.importSwiftyJSON(filename) {
                    let importSuccessful = JSONManager.seedJsonResultsToCoreData(json, context: viewContext, type: Profession.self)
                    DDLogDebug("keyPath: \(keyPath) Successful: \(importSuccessful)")
                    UserDefaults.standard.setValue(importSuccessful, forKeyPath: keyPath)
                }
            case .signerWritings:
                if let json = JSONManager.importSwiftyJSON(filename) {
                    let importSuccessful = true
                    DDLogDebug("keyPath: \(keyPath) Successful: \(importSuccessful)")
                    UserDefaults.standard.setValue(importSuccessful, forKeyPath: keyPath)
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
