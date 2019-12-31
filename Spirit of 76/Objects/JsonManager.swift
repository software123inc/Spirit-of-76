//
//  JsonManager.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 12/30/19.
//  Copyright © 2019 Tim W. Newton. All rights reserved.
//

import Foundation

class JSONManager {
    static func doImport() {
        let files = Bundle.main.paths(forResourcesOfType: "json", inDirectory: nil)
        var results:Decodable?
        for file in files.sorted() {
            let filename = file.lastPathComponenSansExtension
            
            let f = DefaultFiles.init(rawValue: filename)
            
            switch f {
            case .cities:
                let _ = JSONManager.importJson(filename, type:JCities.self)
            //                print(results as Any)
            case .countries:
                let _ = JSONManager.importJson(filename, type:JCountries.self)
            //                print(results as Any)
            case .events:
                let _ = JSONManager.importJson(filename, type:JEvents.self)
            //                print(results as Any)
            case .quotes:
                let _ = JSONManager.importJson(filename, type:JQuotes.self)
            //                print(results as Any)
            case .signerEducation:
                results = JSONManager.importJson(filename, type:JSignerEducations.self)
            //                print(results as Any)
            case .signerFacts:
                results = JSONManager.importJson(filename, type:JSignerFacts.self)
            //                print(results as Any)
            case .signerProfessions:
                results = JSONManager.importJson(filename, type:JSignerProfessions.self)
            //                print(results as Any)
            case .signerWritings:
                results = JSONManager.importJson(filename, type:JSignerWritings.self)
            //                print(results as Any)
            case .states:
                results = JSONManager.importJson(filename, type:JStates.self)
            //                print(results as Any)
            case .topics:
                results = JSONManager.importJson(filename, type:JTopics.self)
            //                print(results as Any)
            case .writings:
                results = JSONManager.importJson(filename, type:JWritings.self)
            //                print(results as Any)
            case .signers_default:
                results = JSONManager.importJson(filename, type:JSigners.self)
            default:
                print("Unhandled file '\(filename)'")
            }
        }
    }
    
    static func importJson<T: Decodable>(_ filename:String, type: T.Type) -> T? {
        var results:T?
        
        if let filepath = Bundle.main.path(forResource: filename, ofType: "json") {
            do {
                guard let data = try String(contentsOfFile: filepath).data(using: .utf8) else { return nil }
                
                let decoder = JSONDecoder()
                results = try? decoder.decode(type, from: data)
            } catch {
                debugPrint(error.localizedDescription)
            }
        } else {
            debugPrint("File not found.")
        }
        
        return results
    }
}

enum DefaultFiles:String {
    case cities,
    countries,
    events,
    quotes,
    signerEducation,
    signerFacts,
    signerProfessions,
    signerWritings,
    signers_default,
    states,
    topics,
    writings
}
