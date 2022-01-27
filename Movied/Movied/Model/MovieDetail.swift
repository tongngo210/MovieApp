import Foundation

struct MovieDetail: Decodable {
    let id: Int
    let title: String?
    let poster: String?
    let backgroundPoster: String?
    let releaseDate: String?
    let synopsis: String?
    let genres: [Genre]?
    let voteRate: Double?
    let duration: Int?
    let languages: [Language]?
    
    private enum CodingKeys: String, CodingKey {
        case id, genres
        case title = "original_title"
        case poster = "poster_path"
        case backgroundPoster = "backdrop_path"
        case releaseDate = "release_date"
        case synopsis = "overview"
        case voteRate = "vote_average"
        case duration = "runtime"
        case languages = "spoken_languages"
    }
}
