import UIKit

final class UserViewController: UIViewController {
    
    @IBOutlet weak var userLikedMoviesCollectionView: UICollectionView!
    
    var viewModel: UserViewControllerViewModel!
    var coordinator: UserViewControllerCoordinator!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        coordinator.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configViewModel()
        configView()
    }

}
//MARK: - Configure UI and View Model
extension UserViewController {
    private func configView() {
        configCollectionView()
    }
    
    private func configViewModel() {
        viewModel.showIndicator = { [weak self] bool in
            DispatchQueue.main.async {
                self?.showIndicator(bool)
            }
        }
        viewModel.reloadCollectionView = { [weak self] in
            DispatchQueue.main.async {
                self?.userLikedMoviesCollectionView.reloadData()
            }
        }
    }
    
    private func configCollectionView() {
        userLikedMoviesCollectionView.delegate = self
        userLikedMoviesCollectionView.dataSource = self
        userLikedMoviesCollectionView.registerNib(cellName: LikedMovieItemCollectionViewCell.className)
        userLikedMoviesCollectionView.registerNib(cellName: UserInfoCollectionViewCell.className)
    }
}
//MARK: - Collection View Datasource
extension UserViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfAllLikedMovieCells + 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let numberOfAllCells = viewModel.numberOfAllLikedMovieCells + 1
        if 0..<numberOfAllCells ~= indexPath.item {
            if indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(withClass: UserInfoCollectionViewCell.self,
                                                              for: indexPath)
                cell.viewModel = viewModel.getUserInfoCellViewModel()
                cell.delegate = self
                return cell
            }
            let cell = collectionView.dequeueReusableCell(withClass: LikedMovieItemCollectionViewCell.self,
                                                          for: indexPath)
            let cellViewModel = viewModel.getLikedMovieCellViewModel(at: indexPath)
            cell.viewModel = cellViewModel
            return cell
        }
        return UICollectionViewCell()
    }
}
//MARK: - Collection View Delegate
extension UserViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        if 1..<viewModel.numberOfAllLikedMovieCells + 1 ~= indexPath.item {
            let movieCellModel = viewModel.getLikedMovieCellViewModel(at: indexPath)
            let movieDetailVC: MovieDetailViewController = .instantiate(storyboardName: MovieDetailViewController.className)
            let movieDetailViewModel = MovieDetailViewControllerViewModel(movieId: movieCellModel.movieId)
            
            movieDetailVC.movieDetailViewModel = movieDetailViewModel
            navigationController?.pushViewController(movieDetailVC, animated: true)
        }
    }
}
//MARK: - CollectionView Flow Layour
extension UserViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            return CGSize(width: userLikedMoviesCollectionView.frame.width,
                          height: view.frame.height / 2)
        } else {
            return CGSize(width: userLikedMoviesCollectionView.frame.width / 4,
                          height: userLikedMoviesCollectionView.frame.width / 3 + 10)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
}
//MARK: - UserInfoCollectionViewCell Delegate
extension UserViewController: UserInfoCollectionViewCellDelegate {
    func didTapSetting() {
        coordinator.showPopUpView()
    }
}
