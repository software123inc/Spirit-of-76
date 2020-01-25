//
//  AppStoreReviewManager.swift
//  Spirit of 76
//
//  Created by Tim Newton on 1/25/20.
//  Copyright © 2020 Tim W. Newton. All rights reserved.
//

import StoreKit

enum AppStoreReviewManager {
    static func requestReviewIfAppropriate() {
        SKStoreReviewController.requestReview()
    }
}
