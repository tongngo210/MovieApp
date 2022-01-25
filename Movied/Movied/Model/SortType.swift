import Foundation

enum SortType: CaseIterable {
    case oldestToNewest
    case newestToOldest
    case aToZ
    case zToA
    case rateIncrease
    case rateDecrease
    
    var title: String {
        switch self {
        case .oldestToNewest:
            return "Oldest to Newest"
        case .newestToOldest:
            return "Newest to Oldest"
        case .aToZ:
            return "A to Z"
        case .zToA:
            return "Z to A"
        case .rateIncrease:
            return "Rate Increase"
        case .rateDecrease:
            return "Rate Decrease"
        }
    }
    
    var apiParam: String {
        switch self {
        case .oldestToNewest:
            return "release_date.asc"
        case .newestToOldest:
            return "release_date.desc"
        case .aToZ:
            return "original_title.asc"
        case .zToA:
            return "original_title.desc"
        case .rateIncrease:
            return "vote_average.asc"
        case .rateDecrease:
            return "vote_average.desc"
        }
    }
}
