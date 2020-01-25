//
//  JsonImport+Enhancements.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 1/17/20.
//  Copyright © 2020 Tim W. Newton. All rights reserved.
//

import CoreData
import UIKit
import CocoaLumberjackSwift

extension JsonImport {
    static var favoritesCount:Int {
        let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        var count = 0
        do {
            let fr:NSFetchRequest<JsonImport> = JsonImport.fetchRequest()
            fr.predicate = K.Predicate.isFavorite
            
            count =  try viewContext.count(for: fr)
        }
        catch {
            DDLogWarn(error.localizedDescription)
        }
        
        return count
    }
    
    static var hasFavorites:Bool {
        return JsonImport.favoritesCount > 0
    }
}

extension JsonImport: CardSummary {
    @objc
    var cardTitle: String {
        return ""
    }
    
    @objc
    var cardDetailText: String {
        return ""
    }
    
    @objc
    var cardIsFavorite: Bool {
        get {
            return self.isFavorite
        }
        
        set {
            self.isFavorite = newValue
        }
    }
    
    @objc
    var cardImage: UIImage?  {
        if let imageName = self.imageName {
            return UIImage.init(named: imageName)
        }
        
        return K.Image.fife_and_drum
    }
}

extension JsonImport: FavoriteSummary {
    @objc
    var itemIsFavorite: Bool {
        get {
            return self.isFavorite
        }
        
        set {
            self.isFavorite = newValue
        }
    }
    
    @objc
    var favoriteTitle: String {
        return ""
    }
    
    @objc
    var favoriteDetailText: String {
        return ""
    }
    
    @objc
    var favoriteImage: UIImage? {
        if let imageName = self.imageName {
            return UIImage.init(named: imageName)
        }
        
        return K.Image.fife_and_drum
    }
    
    @objc
    var favoriteAvatar: UIImage? {
        if let imageName = self.imageName {
            return UIImage.init(named: "Avatars/\(imageName)")
        }
        
        return nil
    }
}
