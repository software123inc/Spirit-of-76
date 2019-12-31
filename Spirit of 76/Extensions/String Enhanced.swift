//
//  String Enhanced.swift
//  GM Helper
//
//  Created by Tim W. Newton on 12/24/19.
//  Copyright © 2019 Tim W. Newton. All rights reserved.
//

import Foundation

extension String {
    var fileURL: URL {
        return URL(fileURLWithPath: self)
    }
    var pathExtension: String {
        return fileURL.pathExtension
    }
    var lastPathComponent: String {
        return fileURL.lastPathComponent
    }
    
    var lastPathComponenSansExtension: String {
        return fileURL.deletingPathExtension().lastPathComponent
    }
}
