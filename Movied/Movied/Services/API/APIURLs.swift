import Foundation

enum APIURLs {
    enum Image {
        static let original = "https://image.tmdb.org/t/p/original"
        static let w500 = "https://image.tmdb.org/t/p/w500"
    }
    
    static let scheme = "https"
    static let host = "api.themoviedb.org"
    static let version = "/3"
    private static let movie = version + "/movie"
    static let discoverMovies = version + "/discover/movie"
    static let movieDetail = movie + "/%d"
    static let movieActors = movie + "/%d/credits"
    static let movieTrailers = movie + "/%d/videos"
}
