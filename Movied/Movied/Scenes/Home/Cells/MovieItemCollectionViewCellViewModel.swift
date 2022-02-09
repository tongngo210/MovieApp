import Foundation

struct MovieItemCollectionViewCellViewModel {
    let movieId: Int
    let movieImageURLString: String
    let movieNameText: String
    let movieRateText: String
    
    init(movie: Movie) {
        movieId = movie.id
        movieImageURLString = movie.poster ?? ""
        movieNameText = movie.title ?? ""
        movieRateText = "\(movie.voteRate ?? 0)"
    }
}
