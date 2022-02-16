import Foundation

class FavoriteViewControllerViewModel {
    private var favoriteMovies: [FavoriteMovie] = []
    private (set) var favoriteMovieCellViewModels: [FavoriteMovieItemTableViewCellViewModel] = []
    
    var reloadTableView: (() -> ())?
    
    //MARK: - Core Data
    func loadFavoriteMovies() {
        CoreDataService.shared.loadListOfFavoriteMovies(predicate: nil) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    if let favoriteMovies = data {
                        self.favoriteMovies = favoriteMovies
                        self.createFavoriteMoviesCellViewModels(favoriteMovies: favoriteMovies)
                        self.reloadTableView?()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func deleteFavoriteMovie(indexPath: IndexPath) {
        CoreDataService.shared.deleteFavoriteMovie(item: favoriteMovies[indexPath.item]) { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.deleteFavoriteMovieCellViewModel(at: indexPath)
                self.reloadTableView?()
            }
        }
    }
    
    //MARK: - Favorite Movie Cell
    private func createFavoriteMoviesCellViewModels(favoriteMovies: [FavoriteMovie]) {
        var viewModels = [FavoriteMovieItemTableViewCellViewModel]()
        for movie in favoriteMovies {
            viewModels.append(FavoriteMovieItemTableViewCellViewModel(favoriteMovie: movie))
        }
        favoriteMovieCellViewModels = viewModels
    }
    
    var numberOfAllFavoriteMovieCells: Int {
        return favoriteMovieCellViewModels.count
    }
    
    func getFavoriteMovieCellViewModel(at indexPath: IndexPath) -> FavoriteMovieItemTableViewCellViewModel {
        return favoriteMovieCellViewModels[indexPath.item]
    }
    
    private func deleteFavoriteMovieCellViewModel(at indexPath: IndexPath) {
        favoriteMovieCellViewModels.remove(at: indexPath.item)
    }
}
