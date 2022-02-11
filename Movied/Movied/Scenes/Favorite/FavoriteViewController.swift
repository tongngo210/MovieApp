import UIKit

final class FavoriteViewController: UIViewController {

    @IBOutlet private weak var favoriteTitle: UILabel!
    @IBOutlet private weak var favoriteMovieListTableView: UITableView!
    
    private var favoriteViewModel = FavoriteViewControllerViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configViewModel()
        configView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoriteViewModel.loadFavoriteMovies()
    }
}
//MARK: - Configure UI
extension FavoriteViewController {
    private func configViewModel() {
        favoriteViewModel.reloadTableView = { [weak self] in
            self?.favoriteMovieListTableView.reloadData()
        }
    }
    
    private func configView() {
        favoriteTitle.text = Title.favorite
        configTableView()
    }
    
    private func configTableView() {
        favoriteMovieListTableView.separatorStyle = .none
        favoriteMovieListTableView.delegate = self
        favoriteMovieListTableView.dataSource = self
        favoriteMovieListTableView.rowHeight = favoriteMovieListTableView.frame.height / 4
        favoriteMovieListTableView.registerNib(cellName: FavoriteMovieItemTableViewCell.className)
    }
}
//MARK: - Table View Datasource
extension FavoriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return favoriteViewModel.numberOfAllFavoriteMovieCells
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: FavoriteMovieItemTableViewCell.self,
                                                 for: indexPath)
        if 0..<favoriteViewModel.numberOfAllFavoriteMovieCells ~= indexPath.item {
            let movieCellViewModel = favoriteViewModel.getFavoriteMovieCellViewModel(at: indexPath)
            cell.favoriteMovieImageView.getImageFromURL(APIURLs.Image.original + movieCellViewModel.movieImageURLString)
            cell.favoriteMovieNameLabel.text = movieCellViewModel.movieNameText
            cell.favoriteMovieRateLabel.text = "\(movieCellViewModel.movieRateText)"
            cell.favoriteMovieOverviewLabel.text = movieCellViewModel.movieOverviewText
        }
        return cell
    }
}
//MARK: - Table View Delegate
extension FavoriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        if 0..<favoriteViewModel.numberOfAllFavoriteMovieCells ~= indexPath.item {
            let movieCellViewModel = favoriteViewModel.getFavoriteMovieCellViewModel(at: indexPath)
            let movieDetailVC: MovieDetailViewController = .instantiate(storyboardName: MovieDetailViewController.className)
            let movieDetailViewModel = MovieDetailViewControllerViewModel(movieId: movieCellViewModel.movieId)
            
            movieDetailVC.movieDetailViewModel = movieDetailViewModel
            navigationController?.pushViewController(movieDetailVC, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction: UIContextualAction = {
            let action = UIContextualAction(style: .destructive,
                                            title: "") { [weak self] _, _, completion in
                self?.favoriteViewModel.deleteFavoriteMovie(indexPath: indexPath)
                completion(true)
            }
            
            let iconSize = CGSize(width: favoriteMovieListTableView.rowHeight / 4,
                                  height: favoriteMovieListTableView.rowHeight / 4)
            action.image = UIImage(systemName: Name.Image.trash)?
                .colored(.red, size: iconSize)
            action.backgroundColor = favoriteMovieListTableView.backgroundColor
            
            return action
        }()
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

