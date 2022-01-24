import Foundation

struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]?
    
    init(path: String, queryItems: [URLQueryItem]?) {
        self.path = path
        self.queryItems = [URLQueryItem(name: "api_key", value: APIKey.apiKey)] + (queryItems ?? [] )
    }
}

extension Endpoint {
    var url: URL? {
        var components = URLComponents()
        components.scheme = APIURLs.scheme
        components.host = APIURLs.host
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
    
    static func moviesFromNowPlaying(page: Int) -> Endpoint {
        return Endpoint(path: APIURLs.nowPlaying,
                        queryItems: [URLQueryItem(name: "page", value: "\(page)")])
    }
    
    static func movieDetail(id: Int) -> Endpoint {
        return Endpoint(path: String(format: APIURLs.movieDetail, id),
                        queryItems: nil)
    }
    
    static func movieActors(id: Int) -> Endpoint {
        return Endpoint(path: String(format: APIURLs.movieActors, id),
                        queryItems: nil)
    }
}
