import Foundation

struct MovieList: Decodable {
    let page: Int
    let results: [Movie]
}

struct Movie: Decodable {
    let id: Int
    let title: String?
    let poster: String?
    let backgroundPoster: String?
    let releaseDate: String?
    let voteRate: Double?
    
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title = "original_title"
        case poster = "poster_path"
        case backgroundPoster = "backdrop_path"
        case releaseDate = "release_date"
        case voteRate = "vote_average"
    }
}
