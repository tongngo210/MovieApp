import UIKit

final class SearchViewController: UIViewController {
    
    @IBOutlet private weak var notFoundView: UIView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var searchTypeSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var searchResultCollectionView: UICollectionView!

    private var searchViewModel = SearchViewControllerViewModel()
    private var refreshFooterView: RefreshFooterView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configViewModel()
        configView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func didTapSearchForDataButton(_ sender: UIButton) {
        guard let searchQuery = searchBar.text, !searchQuery.isEmpty else {
            notFoundView.isHidden = false
            return
        }
        searchViewModel.fetchFirstPageSearch(query: searchQuery)
    }
    
    @IBAction func didChangedSearchType(_ sender: UISegmentedControl) {
        if SearchType.allCases.indices ~= sender.selectedSegmentIndex {
            searchViewModel.didChangeSearchType(index: sender.selectedSegmentIndex)
        }
    }
}
//MARK: - Configure UI
extension SearchViewController {
    private func configViewModel() {
        searchViewModel.reloadCollectionView = { [weak self] in
            self?.searchResultCollectionView.reloadData()
        }
        
        searchViewModel.showNotFoundView = { [weak self] bool in
            self?.notFoundView.isHidden = !bool
        }
    }
    
    private func configView() {
        configSearchBar()
        configSegmentedControl()
        configCollectionView()
        configNotFoundView()
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
    
    private func configNotFoundView() {
        notFoundView.isHidden = true
        notFoundView.backgroundColor = searchResultCollectionView.backgroundColor
    }
    
    private func configCollectionView() {
        searchResultCollectionView.backgroundView = notFoundView
        searchResultCollectionView.delegate = self
        searchResultCollectionView.dataSource = self
        searchResultCollectionView.registerNib(cellName: MovieItemCollectionViewCell.className)
        searchResultCollectionView.registerNib(cellName: ActorItemCollectionViewCell.className)
        searchResultCollectionView.registerNib(reusableView: RefreshFooterView.className,
                                               kind: UICollectionView.elementKindSectionFooter)
    }
}
//MARK: - CollectionView Datasource
extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        switch searchViewModel.searchType {
        case .movie:
            return searchViewModel.numberOfAllMovieCells
        case .actor:
            return searchViewModel.numberOfAllActorsCells
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch searchViewModel.searchType {
        case .movie:
            let cell = collectionView.dequeueReusableCell(withClass: MovieItemCollectionViewCell.self,
                                                          for: indexPath)
            if 0..<searchViewModel.numberOfAllMovieCells ~= indexPath.item {
                let movieCellViewModel = searchViewModel.getMovieCellViewModel(at: indexPath)
                cell.movieImageView.getImageFromURL(APIURLs.Image.original + movieCellViewModel.movieImageURLString)
                cell.movieNameLabel.text = movieCellViewModel.movieNameText
                cell.movieRateLabel.text = "\(movieCellViewModel.movieRateText)"
            }
            return cell
        case .actor:
            let cell = collectionView.dequeueReusableCell(withClass: ActorItemCollectionViewCell.self,
                                                          for: indexPath)
            if 0..<searchViewModel.numberOfAllActorsCells ~= indexPath.item {
                let actorCellViewModel = searchViewModel.getActorCellViewModel(at: indexPath)
                cell.actorNameLabel.text = actorCellViewModel.actorNameText
                cell.actorImageView.getImageFromURL(APIURLs.Image.original + actorCellViewModel.actorImageURLString)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if searchViewModel.searchType == .movie,
           0..<searchViewModel.numberOfAllMovieCells ~= indexPath.item {
            let movieCellModel = searchViewModel.getMovieCellViewModel(at: indexPath)
            let movieDetailVC: MovieDetailViewController = .instantiate(storyboardName: MovieDetailViewController.className)
            let movieDetailViewModel = MovieDetailViewControllerViewModel(movieId: movieCellModel.movieId)
            
            movieDetailVC.movieDetailViewModel = movieDetailViewModel
            
            navigationController?.pushViewController(movieDetailVC, animated: true)
            navigationController?.navigationBar.isHidden = false
        }
    }
}
//MARK: - CollectionView Datasource
extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footerView = collectionView.dequeueReusableSupplementaryView(withClass: RefreshFooterView.self,
                                                                             kind: kind,
                                                                             for: indexPath)
            refreshFooterView = footerView
            refreshFooterView?.backgroundColor = .clear
            
            switch searchViewModel.searchType {
            case .movie:
                refreshFooterView?.isHidden = searchViewModel.numberOfAllMovieCells == 0
            case .actor:
                refreshFooterView?.isHidden = searchViewModel.numberOfAllActorsCells == 0
            }
    
            return footerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplaySupplementaryView view: UICollectionReusableView,
                        forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            refreshFooterView?.startAnimating()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplayingSupplementaryView view: UICollectionReusableView,
                        forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            refreshFooterView?.stopAnimating()
        }
    }
    
    // Loadmore movies
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        var lastItem = 0
        switch searchViewModel.searchType {
        case .movie:
            lastItem = searchViewModel.numberOfAllMovieCells - 1
        case .actor:
            lastItem = searchViewModel.numberOfAllActorsCells - 1
        }
        if indexPath.item == lastItem {
            searchViewModel.loadMoreResult()
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
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width,
                      height: 55)
    }
}
