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
}
