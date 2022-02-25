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
                                                           image: UIImage(systemName: Name.SystemImage.house),
                                                           selectedImage: nil)
        let homeVC: HomeViewController = .instantiate(storyboardName: HomeViewController.className)
        homeNavigationController.pushViewController(homeVC, animated: true)
        //User Tabbar Item
        let userNavigationController = UINavigationController()
        userNavigationController.tabBarItem = UITabBarItem(title: nil,
                                                           image: UIImage(systemName: Name.SystemImage.person),
                                                           selectedImage: nil)
        userNavigationController.navigationBar.isHidden = true
        let userCoordinator = UserViewControllerCoordinator(window: window,
                                                            navigationController: userNavigationController)
        userCoordinator.start()
        
        mainVC.viewControllers = [homeNavigationController, userNavigationController]
        window?.rootViewController = mainVC
    }

    func finish() {
    }
}
