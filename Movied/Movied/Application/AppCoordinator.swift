import UIKit

class AppCoordinator {

    var window: UIWindow?

    init(window: UIWindow?) {
        self.window = window
    }

    func start() {
        let navigationController = UINavigationController()
        let loginCoordinator = LoginViewControllerCoordinator(window: window,
                                                              navigationController: navigationController)
        loginCoordinator.start()
        window?.makeKeyAndVisible()
    }

    func finish() {
    }
}
