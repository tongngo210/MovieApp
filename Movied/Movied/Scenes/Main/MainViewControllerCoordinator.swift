import UIKit

class MainViewControllerCoordinator: Coordinator {
    weak var navigationController: UINavigationController?
    weak var window: UIWindow?
    
    init(window: UIWindow?, navigationController: UINavigationController?) {
        self.window = window
        self.navigationController = navigationController
    }
    
    func start() {
        let mainVC: MainViewController = .instantiate(storyboardName: MainViewController.className)
        mainVC.coordinator = self
        
        //Home Tabbar Item
        let homeNavigationController = UINavigationController()
        homeNavigationController.tabBarItem = UITabBarItem(title: nil,
                                                           image: UIImage(systemName: Name.SystemImage.homeTabbarItem),
                                                           selectedImage: nil)
        let homeCoordinator = HomeViewControllerCoordinator(navigationController: homeNavigationController)
        homeCoordinator.start()
        
        //Search Tabbar Item
        let searchNavigationController = UINavigationController()
        searchNavigationController.tabBarItem = UITabBarItem(title: nil,
                                                             image: UIImage(systemName: Name.SystemImage.searchTabbarItem),
                                                             selectedImage: nil)
        let searchCoordinator = SearchViewControllerCoordinator(navigationController: searchNavigationController)
        searchCoordinator.start()
        
        //Favorite Tabbar Item
        let favoriteNavigationController = UINavigationController()
        favoriteNavigationController.tabBarItem = UITabBarItem(title: nil,
                                                               image: UIImage(systemName: Name.SystemImage.favoriteTabbarItem),
                                                               selectedImage: nil)
        let favoriteCoordinator = FavoriteViewControllerCoordinator(navigationController: favoriteNavigationController)
        favoriteCoordinator.start()
        
        mainVC.viewControllers = [homeNavigationController,
                                  searchNavigationController,
                                  favoriteNavigationController]
        
        window?.rootViewController = mainVC
    }
    
    func finish() {
    }
    
    
}
