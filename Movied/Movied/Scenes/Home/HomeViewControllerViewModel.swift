import Foundation

final class HomeViewControllerViewModel {
    private (set) var sortType: SortType = .newestToOldest
    private (set) var pageNumber = 1
    private (set) var cellViewModels: [MovieItemCollectionViewCellViewModel] = []
    
    var reloadCollectionView: (() -> ())?
    var endRefreshingControl: (() -> ())?
    var showIndicator: ((Bool) -> ())?
    var updateSortedByTextField: ((String) ->())?
    
    init() {
        fetchFirstPageMovies()
    }
    
//MARK: - Fetch Data
    func fetchFirstPageMovies() {
        showIndicator?(true)
        pageNumber = 1
        APIService.shared.getDiscoverMovies(page: pageNumber,
                                            sortType: sortType) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.showIndicator?(false)
                switch result {
                case .success(let data):
                    if let movieList = data?.results, !movieList.isEmpty {
                        self.createMoviesCells(movies: movieList, isLoadMore: false)
                        self.reloadCollectionView?()
                        self.endRefreshingControl?()
                    }
                case .failure(let error):
                    print(error.rawValue)
                }
            }
        }
    }
    
    func loadMoreMovies() {
        pageNumber += 1
        APIService.shared.getDiscoverMovies(page: pageNumber,
                                            sortType: sortType) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                if let movieList = data?.results, !movieList.isEmpty {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.createMoviesCells(movies: movieList, isLoadMore: true)
                        self.reloadCollectionView?()
                    }
                }
            case .failure(let error):
                self.pageNumber -= 1
                print(error.rawValue)
            }
        }
    }
//MARK: - Movie Cell
    private func createMoviesCells(movies: [Movie], isLoadMore: Bool) {
        var viewModels = [MovieItemCollectionViewCellViewModel]()
        for movie in movies {
            viewModels.append(MovieItemCollectionViewCellViewModel(movie: movie))
        }
        if isLoadMore {
            cellViewModels += viewModels
        } else {
            cellViewModels = viewModels
        }
    }
    
    var numberOfAllMovieCells: Int {
        return cellViewModels.count
    }
    
    func getMovieCellViewModel(at indexPath: IndexPath) -> MovieItemCollectionViewCellViewModel {
        return cellViewModels[indexPath.row]
    }
//MARK: - Action
    func changeSortType(index: Int) {
        sortType = SortType.allCases[index]
        updateSortedByTextField?(sortType.title)
    }
}
