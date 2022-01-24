import Foundation

extension Array where Element == Movie {
    func sortedBy(_ sortType: SortType) -> [Movie] {
        switch sortType {
        case .oldestToNewest:
            return sorted {
                $0.releaseDate?.toDate() ?? Date() < $1.releaseDate?.toDate() ?? Date()
            }
        case .newestToOldest:
            return sorted {
                $0.releaseDate?.toDate() ?? Date() > $1.releaseDate?.toDate() ?? Date()
            }
        case .aToZ:
            return sorted { $0.title ?? "" < $1.title ?? "" }
        case .zToA:
            return sorted { $0.title ?? "" > $1.title ?? "" }
        case .rateIncrease:
            return sorted { $0.voteRate ?? 0 < $1.voteRate ?? 0 }
        case .rateDecrease:
            return sorted { $0.voteRate ?? 0 > $1.voteRate ?? 0 }
        }
    }
}
