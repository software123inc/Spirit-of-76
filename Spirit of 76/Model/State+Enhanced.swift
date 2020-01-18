//
//  State+Enhanced.swift
//  Spirit of 76
//
//  Created by Tim Newton on 1/9/20.
//  Copyright © 2020 Tim W. Newton. All rights reserved.
//

import UIKit
import CoreData
import S123Common
import CocoaLumberjackSwift

extension State {
    var image:UIImage? {
        get {
            if let imageName = self.imageName {
                return UIImage(named: imageName)
            }
            
            return nil
        }
    }
    
    var blueImage:UIImage? {
        get {
            if let imageName = self.imageName {
                return UIImage(named: "\(imageName)_blue")
            }
            
            return nil
        }
    }
}
