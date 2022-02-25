import Foundation

struct User: Codable {
    let userId: String
    let email: String?
    let username: String?
    let profileImageUrl: String?
    let likedMovies: [LikedMovie]
}

struct LikedMovie: Codable {
    let id: Int
    let title: String?
    let poster: String?
}
