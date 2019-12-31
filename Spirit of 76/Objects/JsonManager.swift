//
//  JsonManager.swift
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
        for file in files.sorted() {
            let filename = file.lastPathComponenSansExtension
            if let f = RootFiles.init(rawValue: filename) {
                switch f {
                case .countries:
                    if let json = JSONManager.importSwiftyJSON(filename) {
                        JSONManager.seedJsonResultsToCoreData(json, type: Country.self)
                    }
                case .events:
                    if let json = JSONManager.importSwiftyJSON(filename) {
                        JSONManager.seedJsonResultsToCoreData(json, type: Event.self)
                    }
                case .states:
                    if let json = JSONManager.importSwiftyJSON(filename) {
                        JSONManager.seedJsonResultsToCoreData(json, type: State.self)
                    }
                case .topics:
                    if let json = JSONManager.importSwiftyJSON(filename) {
                        JSONManager.seedJsonResultsToCoreData(json, type: Topic.self)
                    }
                case .writings:
                    if let json = JSONManager.importSwiftyJSON(filename) {
                        JSONManager.seedJsonResultsToCoreData(json, type: Writing.self)
                    }
                }
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
    
    private static func seedJsonResultsToCoreData<T:NSManagedObject>(_ json: JSON, type:T.Type) {
        let newManObj = type.init(context: JSONManager.viewContext)
        
        let firstRec = json[0]
        
        for att in newManObj.entity.attributesByName {
            let key = att.key
            let type = att.value.attributeType
            
            switch type {
            case .stringAttributeType:
                print("key: \(key) \(firstRec[key].string != nil ? "+" : "-")")
            case .booleanAttributeType:
                print("key: \(key) \(firstRec[key].bool != nil ? "+" : "-")")
            case .integer16AttributeType:
                print("key: \(key) \(firstRec[key].int16 != nil ? "+" : "-")")
            case .integer32AttributeType:
                print("key: \(key) \(firstRec[key].int32 != nil ? "+" : "-")")
            case .integer64AttributeType:
                print("key: \(key) \(firstRec[key].int64 != nil ? "+" : "-")")
            case .decimalAttributeType:
                print("key: \(key) \(firstRec[key].number?.decimalValue != nil ? "+" : "-")")
            case .doubleAttributeType:
                print("key: \(key) \(firstRec[key].double != nil ? "+" : "-")")
            case .floatAttributeType:
                print("key: \(key) \(firstRec[key].float != nil ? "+" : "-")")
            case .dateAttributeType:
                if let dateString = firstRec[key].string {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let dateFromString: Date? = dateFormatter.date(from: dateString)
                    dateFormatter.dateFormat = "MMM dd, yyyy"
                    print("key: \(key) \(firstRec[key].string != nil ? "*" : "-")  \(dateFormatter.string(from: dateFromString ?? Date()))")
                }
                else {
                    print("key: \(key) \(firstRec[key].string != nil ? "!" : "-")")
                }
            default:
                debugPrint("key: \(key) !")
            }
        }
        
        //                for (_, subJson):(String, JSON) in json {
        //                    for key in newManObj.entity.attributesByName.keys {
        //                        print("key: \(key) \(subJson[key].string != nil ? "+" : "-")")
        //                    }
        //                }
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
