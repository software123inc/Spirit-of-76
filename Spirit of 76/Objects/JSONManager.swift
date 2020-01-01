//
//  JSONManager.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 12/30/19.
//  Copyright © 2019 Tim W. Newton. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

class JSONManager {
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
                        let importSuccessful = JSONManager.seedJsonResultsToCoreData(json, type: Country.self)
                        print("keyPath: \(keyPath) Successful: \(importSuccessful)")
                        userDefault.setValue(importSuccessful, forKeyPath: keyPath)
                    }
                case .events:
                    if let json = JSONManager.importSwiftyJSON(filename) {
                        let importSuccessful = JSONManager.seedJsonResultsToCoreData(json, type: Event.self)
                        print("keyPath: \(keyPath) Successful: \(importSuccessful)")
                        userDefault.setValue(importSuccessful, forKeyPath: keyPath)
                    }
                case .states:
                    if let json = JSONManager.importSwiftyJSON(filename) {
                        let importSuccessful = JSONManager.seedJsonResultsToCoreData(json, type: State.self)
                        print("keyPath: \(keyPath) Successful: \(importSuccessful)")
                        userDefault.setValue(importSuccessful, forKeyPath: keyPath)
                    }
                case .topics:
                    if let json = JSONManager.importSwiftyJSON(filename) {
                        let importSuccessful = JSONManager.seedJsonResultsToCoreData(json, type: Topic.self)
                        print("keyPath: \(keyPath) Successful: \(importSuccessful)")
                        userDefault.setValue(importSuccessful, forKeyPath: keyPath)
                    }
                case .writings:
                    if let json = JSONManager.importSwiftyJSON(filename) {
                        let importSuccessful = JSONManager.seedJsonResultsToCoreData(json, type: Writing.self)
                        print("keyPath: \(keyPath) Successful: \(importSuccessful)")
                        userDefault.setValue(importSuccessful, forKeyPath: keyPath)
                    }
                }
            }
            else {
                debugPrint("\(keyPath) previously imported.")
            }
        }
    }
    
    private static func importSwiftyJSON(_ filename:String) -> JSON? {
        var json:JSON?
        
        if let filepath = Bundle.main.path(forResource: filename, ofType: "json") {
            do {
                if let dataFromString = try String(contentsOfFile: filepath).data(using: .utf8, allowLossyConversion: false) {
                    json = try JSON(data: dataFromString)["records"]
                }
            } catch {
                debugPrint(error.localizedDescription)
            }
        } else {
            debugPrint("File not found.")
        }
        
        return json
    }
    
    private static func seedJsonResultsToCoreData<T:NSManagedObject>(_ json: JSON, type:T.Type) -> Bool {
        var isSuccessful = false
        let newManObj = type.init(context: JSONManager.viewContext)
//        print("== Begin \(type.entity().name ?? "unknown entity") ==")
        
        for (_, record):(String, JSON) in json {
            for att in newManObj.entity.attributesByName {
                let key = att.key
                let type = att.value.attributeType
                
                switch type {
                case .stringAttributeType:
                    //                print("key: \(key) \(record[key].string != nil ? "+" : "-")")
                    newManObj.setValue(record[key].string, forKey: key)
                case .booleanAttributeType:
                    newManObj.setValue(record[key].bool, forKey: key)
                //                print("key: \(key) \(record[key].bool != nil ? "+" : "-")")
                case .integer16AttributeType:
                    newManObj.setValue(record[key].int16, forKey: key)
//                    print("key: \(key) \(record[key].int16 != nil ? "+" : "-")")
                case .integer32AttributeType:
                    newManObj.setValue(record[key].int32, forKey: key)
                //                print("key: \(key) \(record[key].int32 != nil ? "+" : "-")")
                case .integer64AttributeType:
                    newManObj.setValue(record[key].int64, forKey: key)
                //                print("key: \(key) \(record[key].int64 != nil ? "+" : "-")")
                case .decimalAttributeType:
                    newManObj.setValue(record[key].number?.decimalValue, forKey: key)
                //                print("key: \(key) \(record[key].number?.decimalValue != nil ? "+" : "-")")
                case .doubleAttributeType:
                    newManObj.setValue(record[key].double, forKey: key)
                //                print("key: \(key) \(record[key].double != nil ? "+" : "-")")
                case .floatAttributeType:
                    newManObj.setValue(record[key].float, forKey: key)
                //                print("key: \(key) \(record[key].float != nil ? "+" : "-")")
                case .dateAttributeType:
                    if let dateString = record[key].string {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        let dateFromString: Date? = dateFormatter.date(from: dateString)
                        
                        newManObj.setValue(dateFromString, forKey: key)
                        //                    dateFormatter.dateFormat = "MMM dd, yyyy"
                        //                    print("key: \(key) \(record[key].string != nil ? "*" : "-")  \(dateFormatter.string(from: dateFromString ?? Date()))")
                    }
                default:
                    debugPrint("unhandled attribute type: \(type) !")
                }
            }
        }
        
        do {
            try JSONManager.viewContext.save()
            isSuccessful = true
        }
        catch {
            debugPrint(error.localizedDescription)
            isSuccessful = false
        }
        
//        print("== End \(type.entity().name ?? "unknown entity") ==")
        return isSuccessful
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
