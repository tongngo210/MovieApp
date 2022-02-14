import Foundation

final class SearchViewControllerViewModel {
    private (set) var searchType: SearchType = .movie
    private (set) var actorSearchPageNumber = 1
    private (set) var movieSearchPageNumber = 1
    private (set) var searchBarText = ""
    
    var reloadCollectionView: (() -> ())?
    var showNotFoundView: ((Bool) -> ())?
    
    private (set) var actorsCellViewModels: [ActorItemCollectionViewCellViewModel] = []
    private (set) var moviesCellViewModels: [MovieItemCollectionViewCellViewModel] = []
    
    //MARK: - Fetch Data
    func fetchFirstPageSearch(query: String) {
        searchBarText = query
        switch searchType {
        case .movie:
            movieSearchPageNumber = 1
            APIService.shared.getMovieSearchResult(page: movieSearchPageNumber,
                                                   query: searchBarText) { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        if let moviesSearchResult = data?.results, !moviesSearchResult.isEmpty {
                            self.showNotFoundView?(false)
                            self.createMoviesCells(movies: moviesSearchResult, isLoadMore: false)
                        } else {
                            self.showNotFoundView?(true)
                            self.createMoviesCells(movies: [], isLoadMore: false)
                        }
                        self.reloadCollectionView?()
                    case .failure(let error):
                        print(error.rawValue)
                    }
                }
            }
        case .actor:
            actorSearchPageNumber = 1
            APIService.shared.getActorSearchResult(page: actorSearchPageNumber,
                                                   query: searchBarText) { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        if let actorSearchResult = data?.results, !actorSearchResult.isEmpty {
                            self.showNotFoundView?(false)
                            self.createActorsCells(actors: actorSearchResult, isLoadMore: false)
                        } else {
                            self.showNotFoundView?(true)
                        }
                        self.reloadCollectionView?()
                    case .failure(let error):
                        print(error.rawValue)
                    }
                }
            }
        }
    }
    
    func loadMoreResult() {
        switch searchType {
        case .movie:
            movieSearchPageNumber += 1
            APIService.shared.getMovieSearchResult(page: movieSearchPageNumber,
                                                   query: searchBarText) { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    switch result {
                    case .success(let data):
                        if let moviesSearchResult = data?.results, !moviesSearchResult.isEmpty {
                            self.createMoviesCells(movies: moviesSearchResult, isLoadMore: true)
                            self.reloadCollectionView?()
                        }
                    case .failure(let error):
                        self.movieSearchPageNumber -= 1
                        print(error.rawValue)
                    }
                }
            }
        case .actor:
            actorSearchPageNumber += 1
            APIService.shared.getActorSearchResult(page: actorSearchPageNumber,
                                                   query: searchBarText) { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    switch result {
                    case .success(let data):
                        if let actorSearchResult = data?.results, !actorSearchResult.isEmpty {
                            self.createActorsCells(actors: actorSearchResult, isLoadMore: true)
                            self.reloadCollectionView?()
                        }
                    case .failure(let error):
                        self.actorSearchPageNumber -= 1
                        print(error.rawValue)
                    }
                }
            }
        }
    }
    //MARK: - Actions
    func didChangeSearchType(index: Int) {
        if index == SearchType.movie.rawValue {
            searchType = .movie
        } else {
            searchType = .actor
        }
        DispatchQueue.main.async {
            self.reloadCollectionView?()
        }
    }
    //MARK: - Actor Cell
    private func createActorsCells(actors: [Actor], isLoadMore: Bool) {
        var viewModels = [ActorItemCollectionViewCellViewModel]()
        for person in actors {
            viewModels.append(ActorItemCollectionViewCellViewModel(actor: person))
        }
        if isLoadMore {
            actorsCellViewModels += viewModels
        } else {
            actorsCellViewModels = viewModels
        }
    }
    
    var numberOfAllActorsCells: Int {
        return actorsCellViewModels.count
    }
    
    func getActorCellViewModel(at indexPath: IndexPath) -> ActorItemCollectionViewCellViewModel {
        return actorsCellViewModels[indexPath.item]
    }
    //MARK: - Movie Cell
    private func createMoviesCells(movies: [Movie], isLoadMore: Bool) {
        var viewModels = [MovieItemCollectionViewCellViewModel]()
        for movie in movies {
            viewModels.append(MovieItemCollectionViewCellViewModel(movie: movie))
        }
        if isLoadMore {
            moviesCellViewModels += viewModels
        } else {
            moviesCellViewModels = viewModels
        }
    }
    
    var numberOfAllMovieCells: Int {
        return moviesCellViewModels.count
    }
    
    func getMovieCellViewModel(at indexPath: IndexPath) -> MovieItemCollectionViewCellViewModel {
        return moviesCellViewModels[indexPath.row]
    }
}
