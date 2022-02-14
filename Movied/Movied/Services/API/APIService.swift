import Foundation

struct APIService {
    
    static let shared = APIService()
    
    private func request<T: Decodable>(from endPoint: Endpoint,
                                       completion: @escaping (Result<T?, APIError>) -> Void) {
        
        guard let url = endPoint.url else {
            completion(.failure(.invalidURL))
            return
        }
        DispatchQueue.global().async {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let _ = error {
                    completion(.failure(.unableToRequest))
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completion(.failure(.invalidResponse))
                    return
                }
                
                guard let safeData = data else {
                    completion(.failure(.unsafeData))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(T.self, from: safeData)
                    completion(.success(result))
                } catch {
                    completion(.failure(.invalidData))
                }
            }.resume()
        }
    }
}

extension APIService {
    func getDiscoverMovies(page: Int, sortType: SortType,
                           completion: @escaping (Result<MovieList?, APIError>) -> Void) {
        request(from: .discoverMovies(page: page, sortType: sortType),
                completion: completion)
    }
    
    func getMovieDetail(id: Int,
                        completion: @escaping (Result<MovieDetail?, APIError>) -> Void) {
        request(from: .movieDetail(id: id), completion: completion)
    }
    
    func getMovieActors(id: Int,
                        completion: @escaping (Result<ActorList?, APIError>) -> Void) {
        request(from: .movieActors(id: id), completion: completion)
    }
    
    func getMovieSearchResult(page: Int, query: String,
                              completion: @escaping (Result<MovieList?, APIError>) -> Void) {
        request(from: .movieSearch(page: page, query: query), completion: completion)
    }
    
    func getActorSearchResult(page: Int, query: String,
                              completion: @escaping (Result<ActorSearchResult?, APIError>) -> Void) {
        request(from: .personSearch(page: page, query: query), completion: completion)
    }
}
