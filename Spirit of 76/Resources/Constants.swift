//
//  Constants.swift
//  Spirit of 76
//
//  Created by Tim Newton on 1/16/20.
//  Copyright © 2020 Tim W. Newton. All rights reserved.
//

import Foundation

struct K {
    static let appName = "Spirit of '76"
    
    struct BrandColors {
        static let cayenne = "BrandCayenne"
    }
    
    struct SegueID {
        static let showAboutDetails = "showAboutDetails"
        static let showPersonDetail = "showPersonDetail"
        static let showEventDetail = "showEventDetail"
        static let showTopicDetail = "showTopicDetail"
        static let showEducation = "showEducation"
        static let showFavoriteDetails = "showFavoriteDetails"
        static let showFacts = "showFacts"
        static let showProfessions = "showProfessions"
        static let showQuotes = "showQuotes"
        static let addCardSummaryContent = "addCardSummaryContent"
        static let moreDetailTextPopover = "moreDetailTextPopover"
    }
    
    struct TVCIdentifier {
        static let aboutCell = "AboutCell"
        static let eventCell = "EventCell"
        static let personCell = "PersonCell"
        static let topicCell = "TopicCell"
        static let favoriteCell = "FavoriteCell"
    }
    
    struct ViewControllerID {
        static let cardSummaryContent = "CardSummaryContent"
    }
}

enum SectionType {
    case main
}
