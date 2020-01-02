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
    private static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private static let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static func importRootData() {
        let files = Bundle.main.paths(forResourcesOfType: "json", inDirectory: nil)
        let userDefault = UserDefaults.standard
        for file in files.sorted() {
            let filename = file.lastPathComponenSansExtension
            let keyPath = "JSONManager_\(filename)"
            let needsImport = !userDefault.bool(forKey: keyPath)
            
            if needsImport, let f = RootFiles.init(rawValue: filename) {
                switch f {
                case .countries:
                    if let json = JSONManager.importSwiftyJSON(filename) {
                        let importSuccessful = JSONManager.seedJsonResultsToCoreData(json, context: viewContext, type: Country.self)
                        DDLogDebug("keyPath: \(keyPath) Successful: \(importSuccessful)")
                        userDefault.setValue(importSuccessful, forKeyPath: keyPath)
                    }
                case .events:
                    if let json = JSONManager.importSwiftyJSON(filename) {
                        let importSuccessful = JSONManager.seedJsonResultsToCoreData(json, context: viewContext, type: Event.self)
                        DDLogDebug("keyPath: \(keyPath) Successful: \(importSuccessful)")
                        userDefault.setValue(importSuccessful, forKeyPath: keyPath)
                    }
                case .states:
                    if let json = JSONManager.importSwiftyJSON(filename) {
                        let importSuccessful = JSONManager.seedJsonResultsToCoreData(json, context: viewContext, type: State.self)
                        DDLogDebug("keyPath: \(keyPath) Successful: \(importSuccessful)")
                        userDefault.setValue(importSuccessful, forKeyPath: keyPath)
                    }
                case .topics:
                    if let json = JSONManager.importSwiftyJSON(filename) {
                        let importSuccessful = JSONManager.seedJsonResultsToCoreData(json, context: viewContext, type: Topic.self)
                        DDLogDebug("keyPath: \(keyPath) Successful: \(importSuccessful)")
                        userDefault.setValue(importSuccessful, forKeyPath: keyPath)
                    }
                case .writings:
                    if let json = JSONManager.importSwiftyJSON(filename) {
                        let importSuccessful = JSONManager.seedJsonResultsToCoreData(json, context: viewContext, type: Writing.self)
                        DDLogDebug("keyPath: \(keyPath) Successful: \(importSuccessful)")
                        userDefault.setValue(importSuccessful, forKeyPath: keyPath)
                    }
                }
            }
            else {
                DDLogDebug("\(keyPath) previously imported.")
            }
        }
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

fileprivate enum SecondaryCountryStateFiles:String {
    case cities,
    signers
}

fileprivate enum TertiarySignerFiles:String {
    case signerEducation,
    signerFacts,
    signerProfessions,
    signerWritings
}

fileprivate enum QuarterlyFiles:String {
    case quotes
}
