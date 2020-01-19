//
//  FavoriteSummary.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 1/17/20.
//  Copyright © 2020 Tim W. Newton. All rights reserved.
//

import UIKit

protocol FavoriteSummary {
    var favoriteTitle:String { get }
    var favoriteDetailText:String { get }
    var favoriteImage:UIImage? { get }
    var favoriteAvatar:UIImage? { get }
    var favoriteSortKey:UIImage? { get }
}
