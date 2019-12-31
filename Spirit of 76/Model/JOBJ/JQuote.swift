//
//  JQuote.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 12/30/19.
//  Copyright © 2019 Tim W. Newton. All rights reserved.
//

import Foundation

struct JQuotes: Codable, Equatable {
    let records:[JQuote]
}

struct JQuote: Codable, Equatable {
    let id: UInt
    let writingID: UInt?
    let quotation: String
    let signerID: UInt
}
