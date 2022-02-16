import UIKit

class HomeViewControllerCoordinator: Coordinator {
    weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func start() {
        let homeVC: HomeViewController = .instantiate(storyboardName: HomeViewController.className)
        let viewModel = HomeViewControllerViewModel()
        homeVC.viewModel = viewModel
        homeVC.coordinator = self
        
        navigationController?.pushViewController(homeVC, animated: true)
    }
    
    func finish() {
    }
    
    func goToMovieDetailScreen(movieId: Int) {
        let movieDetailCoordinator = MovieDetailViewControllerCoordinator(navigationController: navigationController,
                                                                          movieId: movieId)
        movieDetailCoordinator.start()
    }
}
