import Foundation

enum SearchType: Int, CaseIterable {
    case movie = 0, actor
    
    var title: String {
        switch self {
        case .movie:
            return "Movie Name"
        case .actor:
            return "Person Name"
        }
    }
}
