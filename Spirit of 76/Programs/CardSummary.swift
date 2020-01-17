//
//  CardSummary.swift
//  Spirit of 76
//
//  Created by Tim Newton on 1/14/20.
//  Copyright © 2020 Tim W. Newton. All rights reserved.
//

import UIKit

protocol CardSummary {
    var cardTitle:String { get }
    var cardDetailText:String { get }
    var cardIsFavorite:Bool { get set }
    var cardImage:UIImage? { get }
}

extension CardSummary {
    var cardImage:UIImage? {
        return nil
    }
}
