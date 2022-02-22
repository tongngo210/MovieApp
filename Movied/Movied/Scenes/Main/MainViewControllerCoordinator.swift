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

        //User Tabbar Item
        let userNavigationController = UINavigationController()
        userNavigationController.tabBarItem = UITabBarItem(title: nil,
                                                           image: UIImage(systemName: Name.SystemImage.person),
                                                           selectedImage: nil)
        let userCoordinator = UserViewControllerCoordinator(navigationController: userNavigationController)
        userCoordinator.start()
        
        mainVC.viewControllers = [userNavigationController]
        window?.rootViewController = mainVC
    }

    func finish() {
    }
}
