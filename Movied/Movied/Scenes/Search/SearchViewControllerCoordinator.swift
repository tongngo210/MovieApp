import UIKit

class SearchViewControllerCoordinator: Coordinator {
    weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func start() {
        let searchVC: SearchViewController = .instantiate(storyboardName: SearchViewController.className)
        let viewModel = SearchViewControllerViewModel()
        searchVC.viewModel = viewModel
        searchVC.coordinator = self
        
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    func finish() {
    }
    
    func goToMovieDetailScreen(movieId: Int) {
        let movieDetailCoordinator = MovieDetailViewControllerCoordinator(navigationController: navigationController,
                                                                          movieId: movieId)
        movieDetailCoordinator.start()
        navigationController?.navigationBar.isHidden = false
    }
}
