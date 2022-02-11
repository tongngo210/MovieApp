import Foundation

final class MovieDetailViewControllerViewModel {
    
    private let dispatchGroup = DispatchGroup()
    private var movieDetail: MovieDetail?
    private (set) var movieId: Int?
    private (set) var isLiked = false
    private (set) var actorsCellViewModels: [ActorItemCollectionViewCellViewModel] = []
    private (set) var genresCellViewModels: [GenreItemCollectionViewCellViewModel] = []
    
    var updateFavoriteButton: ((Bool) -> ())?
    var reloadCollectionView: (() -> ())?
    var showIndicator: ((Bool) -> ())?
    var fillData: ((_ movieDetail: MovieDetail) -> ())?
    
    init(movieId: Int) {
        self.movieId = movieId
        fetchMovieInfoData()
    }
    //MARK: - Action
    func didTapFavorite() {
        if isLiked {
            deleteFavoriteMovie()
        } else {
            addFavoriteMovie()
        }
    }
    //MARK: - Fetch Data
    private func fetchMovieInfoData() {
        showIndicator?(true)
        dispatchGroup.enter()
        APIService.shared.getMovieDetail(id: movieId ?? 0) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    if let movieDetail = data {
                        self.movieDetail = movieDetail
                        self.fillData?(movieDetail)
                        self.createGenresCells(genres: movieDetail.genres ?? [])
                        self.reloadCollectionView?()
                    }
                case .failure(let error):
                    print(error.rawValue)
                }
            }
            self?.dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        APIService.shared.getMovieActors(id: movieId ?? 0) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    if let movieActors = data {
                        self.createActorsCells(actors: movieActors.cast)
                        self.reloadCollectionView?()
                    }
                case .failure(let error):
                    print(error.rawValue)
                }
            }
            self?.dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.showIndicator?(false)
        }
    }
    //MARK: - Core Data
    private func loadFavoriteMovies(completion: @escaping ([FavoriteMovie]) -> Void) {
        let predicate = NSPredicate(format: "id == \(movieId ?? 0)")
        CoreDataService.shared.loadListOfFavoriteMovies(predicate: predicate) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    if let favoriteMovies = data {
                        completion(favoriteMovies)
                    }
                case .failure(let error):
                    print(error.rawValue)
                }
            }
        }
    }
    
    func checkFavoriteMovie() {
        loadFavoriteMovies { [weak self] favoriteMovies in
            self?.isLiked = favoriteMovies.isEmpty ? false : true
            self?.updateFavoriteButton?(self?.isLiked ?? false)
        }
    }
    
    private func addFavoriteMovie() {
        CoreDataService.shared.createFavoriteMovie { [weak self] newFavoriteMovie in
            newFavoriteMovie.id = Int64(self?.movieDetail?.id ?? 0)
            newFavoriteMovie.title = self?.movieDetail?.title
            newFavoriteMovie.rate = self?.movieDetail?.voteRate ?? 0
            newFavoriteMovie.imageURLString = self?.movieDetail?.poster
            newFavoriteMovie.overview = self?.movieDetail?.synopsis
            self?.isLiked = true
            self?.updateFavoriteButton?(self?.isLiked ?? false)
        }
    }
    
    private func deleteFavoriteMovie() {
        loadFavoriteMovies { [weak self] favoriteMovies in
            for movie in favoriteMovies {
                CoreDataService.shared.deleteFavoriteMovie(item: movie, completion: nil)
            }
            self?.isLiked = false
            self?.updateFavoriteButton?(self?.isLiked ?? false)
        }
    }
    //MARK: - Actor Cell
    private func createActorsCells(actors: [Actor]) {
        var viewModels = [ActorItemCollectionViewCellViewModel]()
        for person in actors {
            viewModels.append(ActorItemCollectionViewCellViewModel(actor: person))
        }
        actorsCellViewModels = viewModels
    }
    
    var numberOfMovieActorsCells: Int {
        return actorsCellViewModels.count
    }
    
    func getMovieActorCellViewModel(at indexPath: IndexPath) -> ActorItemCollectionViewCellViewModel {
        return actorsCellViewModels[indexPath.item]
    }
    //MARK: - Genre Cell
    private func createGenresCells(genres: [Genre]) {
        var viewModels = [GenreItemCollectionViewCellViewModel]()
        for genre in genres {
            viewModels.append(GenreItemCollectionViewCellViewModel(genre: genre))
        }
        genresCellViewModels = viewModels
    }
    
    var numberOfMovieGenresCells: Int {
        return genresCellViewModels.count
    }
    
    func getMovieGenreCellViewModel(at indexPath: IndexPath) -> GenreItemCollectionViewCellViewModel {
        return genresCellViewModels[indexPath.item]
    }
}
