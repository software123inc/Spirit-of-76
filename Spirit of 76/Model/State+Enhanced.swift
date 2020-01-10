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
    var imageName:String {
        get {
            return "\(self.img_map?.allBefore(".png") ?? "?")"
        }
    }
    
    var image:UIImage? {
        get {
            return UIImage(named: self.imageName)
        }
    }
    
    var blueImage:UIImage? {
        get {
            let imgName = "\(self.imageName)_blue"
            return UIImage(named: imgName)
        }
    }
}
