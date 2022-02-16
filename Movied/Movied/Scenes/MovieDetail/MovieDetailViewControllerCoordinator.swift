import UIKit

class MovieDetailViewControllerCoordinator: Coordinator {
    weak var navigationController: UINavigationController?
    private var movieId: Int
    
    init(navigationController: UINavigationController?, movieId: Int) {
        self.navigationController = navigationController
        self.movieId = movieId
    }
    
    func start() {
        let movieDetailVC: MovieDetailViewController = .instantiate(storyboardName: MovieDetailViewController.className)
        let viewModel = MovieDetailViewControllerViewModel(movieId: movieId)
        movieDetailVC.viewModel = viewModel
        movieDetailVC.coordinator = self
        
        navigationController?.pushViewController(movieDetailVC, animated: true)
    }
    
    func finish() {
    }
}
