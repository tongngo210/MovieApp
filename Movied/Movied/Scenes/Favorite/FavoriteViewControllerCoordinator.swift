import UIKit

class FavoriteViewControllerCoordinator: Coordinator {
    weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func start() {
        let favoriteVC: FavoriteViewController = .instantiate(storyboardName: FavoriteViewController.className)
        let viewModel = FavoriteViewControllerViewModel()
        favoriteVC.viewModel = viewModel
        favoriteVC.coordinator = self
        
        navigationController?.pushViewController(favoriteVC, animated: true)
    }
    
    func finish() {
    }
    
    func goToMovieDetailScreen(movieId: Int) {
        let movieDetailCoordinator = MovieDetailViewControllerCoordinator(navigationController: navigationController,
                                                                          movieId: movieId)
        movieDetailCoordinator.start()
    }
}
