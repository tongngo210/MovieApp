import UIKit

final class FavoriteViewController: UIViewController {

    @IBOutlet private weak var favoriteTitleLabel: UILabel!
    @IBOutlet private weak var favoriteMovieListTableView: UITableView!
    
    var viewModel: FavoriteViewControllerViewModel!
    var coordinator: FavoriteViewControllerCoordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configViewModel()
        configView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadFavoriteMovies()
    }
}
//MARK: - Configure UI
extension FavoriteViewController {
    private func configViewModel() {
        viewModel.reloadTableView = { [weak self] in
            self?.favoriteMovieListTableView.reloadData()
        }
    }
    
    private func configView() {
        favoriteTitleLabel.text = Title.favorite
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
        return viewModel.numberOfAllFavoriteMovieCells
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: FavoriteMovieItemTableViewCell.self,
                                                 for: indexPath)
        if 0..<viewModel.numberOfAllFavoriteMovieCells ~= indexPath.item {
            let movieCellViewModel = viewModel.getFavoriteMovieCellViewModel(at: indexPath)
            cell.model = movieCellViewModel
        }
        return cell
    }
}
//MARK: - Table View Delegate
extension FavoriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        if 0..<viewModel.numberOfAllFavoriteMovieCells ~= indexPath.item {
            let movieCellViewModel = viewModel.getFavoriteMovieCellViewModel(at: indexPath)
            coordinator.goToMovieDetailScreen(movieId: movieCellViewModel.movieId)
        }
        DispatchQueue.main.async {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction: UIContextualAction = {
            let action = UIContextualAction(style: .destructive,
                                            title: "") { [weak self] _, _, completion in
                self?.viewModel.deleteFavoriteMovie(indexPath: indexPath)
                DispatchQueue.main.async {
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
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

