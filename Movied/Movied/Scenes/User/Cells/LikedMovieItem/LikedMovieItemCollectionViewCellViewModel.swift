import Foundation

struct LikedMovieItemCollectionViewCellViewModel {
    let movieId: Int
    let movieImageURLString: String
    
    init(likedMovie: LikedMovie) {
        movieId = likedMovie.id
        movieImageURLString = likedMovie.poster ?? ""
    }
}
