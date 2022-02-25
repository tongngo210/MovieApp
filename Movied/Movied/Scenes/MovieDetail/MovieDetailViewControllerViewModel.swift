import Foundation

final class MovieDetailViewControllerViewModel {
    
    private let dispatchGroup = DispatchGroup()
    private var movieDetail: MovieDetail?
    private (set) var movieId: Int?
    private (set) var currentUserId: String?
    private (set) var isFavorited = false
    private (set) var isLiked = false
    private (set) var actorsCellViewModels: [ActorItemCollectionViewCellViewModel] = []
    private (set) var genresCellViewModels: [GenreItemCollectionViewCellViewModel] = []
    
    var updateFavoriteButton: ((Bool) -> ())?
    var updateLikeButton: ((Bool) -> ())?
    var reloadCollectionView: (() -> ())?
    var showIndicator: ((Bool) -> ())?
    var fillData: ((_ movieDetail: MovieDetail) -> ())?
    
    init(movieId: Int) {
        self.movieId = movieId
        self.currentUserId = FirebaseAuthService.shared.getCurrentUserId()
        fetchMovieInfoData()
    }
    //MARK: - Action
    func didTapFavorite() {
        if isFavorited {
            deleteMovieToFavorite()
        } else {
            addMovieToFavorite()
        }
    }
    
    func didTapLike() {
        if isLiked {
            updateLikedMovieToFirestore(isLiked: false, movieDetail: movieDetail)
        } else {
            updateLikedMovieToFirestore(isLiked: true, movieDetail: movieDetail)
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
                        self.createGenresCellViewModels(genres: movieDetail.genres ?? [])
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
                        self.createActorsCellViewModels(actors: movieActors.cast)
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
    private func loadFavoriteMoviesWithMovieId(completion: @escaping ([FavoriteMovie]?) -> Void) {
        let predicate = NSPredicate(format: "id == \(movieId ?? 0)")
        CoreDataService.shared.loadListOfFavoriteMovies(predicate: predicate) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    if let favoriteMovies = data {
                        completion(favoriteMovies)
                    } else {
                        completion(nil)
                    }
                case .failure(let error):
                    completion(nil)
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func checkIfMovieIsFavorited() {
        loadFavoriteMoviesWithMovieId { [weak self] favoriteMovies in
            guard let self = self else { return }
            if let favoriteMovies = favoriteMovies {
                self.isFavorited = favoriteMovies.isEmpty ? false : true
                self.updateFavoriteButton?(self.isFavorited)
            }
        }
    }
    
    private func addMovieToFavorite() {
        CoreDataService.shared.createFavoriteMovie { [weak self] newFavoriteMovie in
            guard let self = self else { return }
            newFavoriteMovie.id = Int64(self.movieDetail?.id ?? 0)
            newFavoriteMovie.title = self.movieDetail?.title
            newFavoriteMovie.rate = self.movieDetail?.voteRate ?? 0
            newFavoriteMovie.imageURLString = self.movieDetail?.poster
            newFavoriteMovie.overview = self.movieDetail?.synopsis
            self.isFavorited = true
            self.updateFavoriteButton?(self.isFavorited)
        }
    }
    
    private func deleteMovieToFavorite() {
        loadFavoriteMoviesWithMovieId { [weak self] favoriteMovies in
            guard let self = self else { return }
            if let favoriteMovies = favoriteMovies {
                CoreDataService.shared.deleteFavoriteMovie(item: favoriteMovies[0],
                                                           completion: nil)
                self.isFavorited = false
                self.updateFavoriteButton?(self.isFavorited)
            }
        }
    }
    //MARK: - Firebase
    private func updateLikedMovieToFirestore(isLiked: Bool, movieDetail: MovieDetail?) {
        let likedMovie = LikedMovie(id: movieDetail?.id ?? 0, title: movieDetail?.title,
                                    poster: APIURLs.Image.original + (movieDetail?.poster ?? ""))
        FirebaseFirestoreService.shared.likeMovie(isLiked, userId: currentUserId ?? "",
                                                  likedMovie: likedMovie) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success():
                self.isLiked = isLiked
                self.updateLikeButton?(self.isLiked)
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    func checkIfMovieIsLiked() {
        FirebaseFirestoreService.shared.getUserProfile(userId: currentUserId ?? "") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                let isliked = !user.likedMovies.filter { $0.id == self.movieDetail?.id }.isEmpty
                self.isLiked = isliked
                self.updateLikeButton?(isliked)
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    //MARK: - Actor Cell
    private func createActorsCellViewModels(actors: [Actor]) {
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
    private func createGenresCellViewModels(genres: [Genre]) {
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
