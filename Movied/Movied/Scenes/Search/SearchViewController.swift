import UIKit

final class SearchViewController: UIViewController {
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var searchTypeSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var searchResultCollectionView: UICollectionView!
    
    private var searchType: SearchType = .movie
    private var movieSearchResult: [Movie] = []
    private var actorSearchResult: [Actor] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func didTapSearchForDataButton(_ sender: UIButton) {
        if searchType == .movie {
            fetchFirstPageMovieSearch()
        } else {
            fetchFirstPageActorSearch()
        }
    }
    
    @IBAction func didChangedSearchType(_ sender: UISegmentedControl) {
        if SearchType.allCases.indices ~= sender.selectedSegmentIndex {
            if sender.selectedSegmentIndex == SearchType.movie.rawValue {
                searchType = .movie
            } else {
                searchType = .actor
            }
            DispatchQueue.main.async { [weak self] in
                self?.searchResultCollectionView.reloadData()
            }
        }
    }
}
//MARK: - Configure UI
extension SearchViewController {
    private func configView() {
        configSearchBar()
        configSegmentedControl()
        configCollectionView()
    }
    
    private func configSegmentedControl() {
        for searchType in SearchType.allCases {
            searchTypeSegmentedControl.setTitle(searchType.title,
                                                forSegmentAt: searchType.rawValue)
        }
    }
    
    private func configSearchBar() {
        searchBar.backgroundImage = UIImage()
    }
    
    private func configCollectionView() {
        searchResultCollectionView.delegate = self
        searchResultCollectionView.dataSource = self
        searchResultCollectionView.registerNib(cellName: MovieItemCollectionViewCell.className)
        searchResultCollectionView.registerNib(cellName: ActorItemCollectionViewCell.className)
    }
}
//MARK: - Fetch Data
extension SearchViewController {
    func fetchFirstPageMovieSearch() {
        guard let searchQuery = searchBar.text, !searchQuery.isEmpty else { return }
        APIService.shared.getMovieSearchResult(page: 1,
                                               query: searchQuery) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    if let moviesSearchResult = data?.results, !moviesSearchResult.isEmpty {
                        self.movieSearchResult = moviesSearchResult
                        self.searchResultCollectionView.reloadData()
                    }
                case .failure(let error):
                    print(error.rawValue)
                }
            }
        }
    }
    
    func fetchFirstPageActorSearch() {
        guard let searchQuery = searchBar.text, !searchQuery.isEmpty else { return }
        APIService.shared.getActorSearchResult(page: 1,
                                               query: searchQuery) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    if let actorSearchResult = data?.results, !actorSearchResult.isEmpty {
                        self.actorSearchResult = actorSearchResult
                        self.searchResultCollectionView.reloadData()
                    }
                case .failure(let error):
                    print(error.rawValue)
                }
            }
        }
    }
}
//MARK: - CollectionView Delegate, Datasource
extension SearchViewController: UICollectionViewDelegate,
                                UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        switch searchType {
        case .movie:
            return movieSearchResult.count
        case .actor:
            return actorSearchResult.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch searchType {
        case .movie:
            let cell = collectionView.dequeueReusableCell(withClass: MovieItemCollectionViewCell.self,
                                                          for: indexPath)
            if movieSearchResult.indices ~= indexPath.item {
//                cell.fillData(with: movieSearchResult[indexPath.item])
            }
            return cell
        case .actor:
            let cell = collectionView.dequeueReusableCell(withClass: ActorItemCollectionViewCell.self,
                                                          for: indexPath)
            if actorSearchResult.indices ~= indexPath.item {
//                cell.fillData(with: actorSearchResult[indexPath.item])
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if searchType == .movie,
           movieSearchResult.indices ~= indexPath.item {
            let movieDetailVC: MovieDetailViewController = .instantiate(storyboardName: MovieDetailViewController.className)
            
//            movieDetailVC.movieId = movieSearchResult[indexPath.item].id
            
            navigationController?.pushViewController(movieDetailVC, animated: true)
            navigationController?.navigationBar.isHidden = false
        }
    }
}
//MARK: - CollectionView Delegate FlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: collectionView.frame.width / 2 - 30,
                          height: collectionView.frame.height / 3 + 12)
        return size
    }
}
