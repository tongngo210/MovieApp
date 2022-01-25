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
    
    func getDiscoverMovies(page: Int, sortType: SortType,
                           completion: @escaping (Result<MovieList?, APIError>) -> Void) {
        request(from: .discoverMovies(page: page, sortType: sortType),
                completion: completion)
    }
}
