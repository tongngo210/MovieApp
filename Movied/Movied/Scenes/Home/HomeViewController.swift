import UIKit

final class HomeViewController: UIViewController {
    @IBOutlet private weak var homeTitle: UILabel!
    @IBOutlet private weak var movieListCollectionView: UICollectionView!
    @IBOutlet private weak var sortedByTextField: UITextField!
    
    private var allMovies: [Movie] = []
    private var sortType: SortType = .newestToOldest
    private var pageNumber = 1
    
    private let refreshControl = UIRefreshControl()
    private let pickerView = UIPickerView()
    private var refreshFooterView: RefreshFooterView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        fetchFirstPageMovies()
    }
    
    //MARK: - Fetch Data
    private func fetchFirstPageMovies() {
        showIndicator(true)
        pageNumber = 1
        APIService.shared.getDiscoverMovies(page: pageNumber,
                                            sortType: sortType) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.showIndicator(false)
                switch result {
                case .success(let data):
                    if let movieList = data?.results, !movieList.isEmpty {
                        self.allMovies = movieList
                        self.movieListCollectionView.reloadData()
                        self.refreshControl.endRefreshing()
                    }
                case .failure(let error):
                    print(error.rawValue)
                }
            }
        }
    }
    
    private func loadMoreMovies() {
        pageNumber += 1
        APIService.shared.getDiscoverMovies(page: pageNumber,
                                            sortType: sortType) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                if let movieList = data?.results, !movieList.isEmpty {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.allMovies += movieList
                        self.movieListCollectionView.reloadData()
                    }
                }
            case .failure(let error):
                self.pageNumber -= 1
                print(error.rawValue)
            }
        }
    }
}
//MARK: - Configure UI
extension HomeViewController {
    private func configView() {
        homeTitle.text = Title.app.uppercased()
        configCollectionView()
        configRefreshControl()
        configPickerView()
        configTextField()
    }
    
    private func configCollectionView() {
        movieListCollectionView.delegate = self
        movieListCollectionView.dataSource = self
        movieListCollectionView.registerNib(cellName: MovieItemCollectionViewCell.className)
        movieListCollectionView.registerNib(reusableView: RefreshFooterView.className,
                                            kind: UICollectionView.elementKindSectionFooter)
        if let heightTabbar = tabBarController?.tabBar.frame.height {
            movieListCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0,
                                                                bottom: heightTabbar,
                                                                right: 0)
        }
    }
    
    private func configPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    private func configTextField() {
        sortedByTextField.text = sortType.title
        sortedByTextField.inputView = pickerView
    }
    
    private func configRefreshControl() {
        refreshControl.addTarget(self,
                                 action: #selector(self.refreshCollectionView),
                                 for: .valueChanged)
        movieListCollectionView.addSubview(refreshControl)
    }
    
    @objc private func refreshCollectionView() {
        fetchFirstPageMovies()
    }
}
//MARK: - CollectionView Datasource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return allMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: MovieItemCollectionViewCell.self,
                                                      for: indexPath)
        
        if allMovies.indices ~= indexPath.item {
            cell.fillData(with: allMovies[indexPath.item])
        }
        
        return cell
    }
}
//MARK: - ColletionView Delegate
extension HomeViewController: UICollectionViewDelegate {
    //MARK: - Config Refresh Footer View and Refresh Action
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footerView = collectionView.dequeueReusableSupplementaryView(withClass: RefreshFooterView.self,
                                                                             kind: kind,
                                                                             for: indexPath)
            refreshFooterView = footerView
            refreshFooterView?.backgroundColor = .clear
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
        let lastItem = allMovies.count - 1
        if indexPath.item == lastItem {
            loadMoreMovies()
        }
    }
    
    //MARK: - Navigation
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
    }
}
//MARK: - CollectionView Delegate FlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
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

//MARK: - PickerView Delegate, Datasource
extension HomeViewController: UIPickerViewDelegate,
                              UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return SortType.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        if SortType.allCases.indices ~= row {
            return SortType.allCases[row].title
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        if SortType.allCases.indices ~= row {
            sortedByTextField.text = SortType.allCases[row].title
            sortType = SortType.allCases[row]
            sortedByTextField.resignFirstResponder()
        }
    }
}
