import Foundation

struct ActorList: Decodable {
    let id: Int
    let cast: [Actor]
}

struct ActorSearchResult: Decodable {
    let page: Int
    let results: [Actor]
    let total_pages: Int
}

struct Actor: Decodable {
    let id: Int
    let name: String?
    let image: String?
    
    private enum CodingKeys: String, CodingKey {
        case id, name
        case image = "profile_path"
    }
}
