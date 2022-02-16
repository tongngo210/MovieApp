import Foundation

struct MovieList: Decodable {
    let page: Int
    let results: [Movie]
    let totalPage: Int
    
    private enum CodingKeys: String, CodingKey {
        case page, results
        case totalPage = "total_pages"
    }
}

struct Movie: Decodable {
    let id: Int
    let title: String?
    let poster: String?
    let backgroundPoster: String?
    let releaseDate: String?
    let voteRate: Double?
    let overview: String?
    
    private enum CodingKeys: String, CodingKey {
        case id, overview
        case title = "original_title"
        case poster = "poster_path"
        case backgroundPoster = "backdrop_path"
        case releaseDate = "release_date"
        case voteRate = "vote_average"
    }
}
