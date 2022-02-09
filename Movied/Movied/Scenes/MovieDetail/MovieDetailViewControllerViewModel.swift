import Foundation

final class MovieDetailViewControllerViewModel {
    
    private let dispatchGroup = DispatchGroup()
    private (set) var movieId: Int?
    
    private (set) var actorsCellViewModels: [ActorItemCollectionViewCellViewModel] = []
    private (set) var genresCellViewModels: [GenreItemCollectionViewCellViewModel] = []
    
    var showIndicator: ((Bool) -> ())?
    var reloadCollectionView: (() -> ())?
    var fillData: ((_ movieDetail: MovieDetail) -> ())?
    
    init(movieId: Int) {
        self.movieId = movieId
        fetchMovieInfoData()
    }
    
    private func fetchMovieInfoData() {
        showIndicator?(true)
        dispatchGroup.enter()
        APIService.shared.getMovieDetail(id: movieId ?? 0) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    if let movieDetail = data {
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
