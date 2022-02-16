import UIKit

final class SearchViewController: UIViewController {
    
    @IBOutlet private weak var notFoundView: UIView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var searchTypeSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var searchResultCollectionView: UICollectionView!

    var viewModel: SearchViewControllerViewModel!
    var coordinator: SearchViewControllerCoordinator!
    
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
        viewModel.fetchFirstPageSearch(query: searchQuery)
    }
    
    @IBAction func didChangedSearchType(_ sender: UISegmentedControl) {
        if SearchType.allCases.indices ~= sender.selectedSegmentIndex {
            viewModel.didChangeSearchType(index: sender.selectedSegmentIndex)
        }
    }
}
//MARK: - Configure UI
extension SearchViewController {
    private func configViewModel() {
        viewModel.reloadCollectionView = { [weak self] in
            self?.searchResultCollectionView.reloadData()
        }
        
        viewModel.showNotFoundView = { [weak self] bool in
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
        switch viewModel.searchType {
        case .movie:
            return viewModel.numberOfAllMovieCells
        case .actor:
            return viewModel.numberOfAllActorsCells
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel.searchType {
        case .movie:
            let cell = collectionView.dequeueReusableCell(withClass: MovieItemCollectionViewCell.self,
                                                          for: indexPath)
            if 0..<viewModel.numberOfAllMovieCells ~= indexPath.item {
                let movieCellViewModel = viewModel.getMovieCellViewModel(at: indexPath)
                cell.movieImageView.getImageFromURL(APIURLs.Image.original + movieCellViewModel.movieImageURLString)
                cell.movieNameLabel.text = movieCellViewModel.movieNameText
                cell.movieRateLabel.text = "\(movieCellViewModel.movieRateText)"
            }
            return cell
        case .actor:
            let cell = collectionView.dequeueReusableCell(withClass: ActorItemCollectionViewCell.self,
                                                          for: indexPath)
            if 0..<viewModel.numberOfAllActorsCells ~= indexPath.item {
                let actorCellViewModel = viewModel.getActorCellViewModel(at: indexPath)
                cell.actorNameLabel.text = actorCellViewModel.actorNameText
                cell.actorImageView.getImageFromURL(APIURLs.Image.original + actorCellViewModel.actorImageURLString)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if viewModel.searchType == .movie,
           0..<viewModel.numberOfAllMovieCells ~= indexPath.item {
            let movieCellViewModel = viewModel.getMovieCellViewModel(at: indexPath)
            coordinator.goToMovieDetailScreen(movieId: movieCellViewModel.movieId)
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
            
            switch viewModel.searchType {
            case .movie:
                refreshFooterView?.isHidden = viewModel.numberOfAllMovieCells == 0
            case .actor:
                refreshFooterView?.isHidden = viewModel.numberOfAllActorsCells == 0
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
        switch viewModel.searchType {
        case .movie:
            lastItem = viewModel.numberOfAllMovieCells - 1
        case .actor:
            lastItem = viewModel.numberOfAllActorsCells - 1
        }
        if indexPath.item == lastItem {
            viewModel.loadMoreResult()
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
