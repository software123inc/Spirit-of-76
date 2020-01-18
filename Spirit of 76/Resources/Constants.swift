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
        static let showFavoriteDetail = "showFavoriteDetail"
        static let showFacts = "showFacts"
        static let showProfessions = "showProfessions"
        static let showQuotes = "showQuotes"
        static let addCardSummaryContent = "addCardSummaryContent"
        static let moreDetailTextPopover = "moreDetailTextPopover"
        static let showFavoriteSigner = "showFavoriteSigner"
        static let showFavoriteEvent = "showFavoriteEvent"
        static let showFavoriteTopic = "showFavoriteTopic"
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


typealias Section = SectionType
enum SectionType {
    case main
}

typealias FavoriteSection = FavoriteSectionType
enum FavoriteSectionType: Int, CaseIterable {
    case education = 0, event, fact, person, profession, quote, topic
    
    func description() -> String {
        switch self {
            case .education:
                return "Education"
            case .event:
                return "Events"
            case .fact:
                return "Facts"
            case .person:
                return "Signers"
            case .profession:
                return "Professions"
            case .quote:
                return "Quotes"
            case .topic:
                return "Topics"
        }
    }
    
    static func typeFromSectionName(_ sectionName:FavoriteSectionEntityNames) -> FavoriteSectionType {
        switch sectionName {
            case .education: return .education
            case .event: return .event
            case .fact: return .fact
            case .person: return .person
            case .profession: return .profession
            case .quote: return .quote
            case .topic: return .topic
        }
    }
}

enum FavoriteSectionEntityNames: String, CaseIterable {
    case education = "Education"
    case event = "Event"
    case fact = "Fact"
    case person = "Person"
    case profession = "Profession"
    case quote = "Quote"
    case topic = "Topic"
    
    func description() -> String {
        switch self {
            case .education:
                return "Education"
            case .event:
                return "Events"
            case .fact:
                return "Facts"
            case .person:
                return "Signers"
            case .profession:
                return "Professions"
            case .quote:
                return "Quotes"
            case .topic:
                return "Topics"
        }
    }
}
