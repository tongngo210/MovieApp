import Foundation

struct FavoriteMovieItemTableViewCellViewModel {
    let movieId: Int
    let movieImageURLString: String
    let movieNameText: String
    let movieRateText: String
    let movieOverviewText: String
    
    init(favoriteMovie: FavoriteMovie) {
        movieId = Int(favoriteMovie.id)
        movieImageURLString = favoriteMovie.imageURLString ?? ""
        movieNameText = favoriteMovie.title ?? ""
        movieRateText = "\(favoriteMovie.rate)"
        movieOverviewText = favoriteMovie.overview ?? ""
    }
}
