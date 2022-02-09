import Foundation

struct GenreItemCollectionViewCellViewModel {
    let genreNameText: String
    
    init(genre: Genre) {
        genreNameText = genre.name
    }
}
