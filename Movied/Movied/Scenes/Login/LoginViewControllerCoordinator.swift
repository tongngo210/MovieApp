import UIKit

final class LoginViewControllerCoordinator: Coordinator {
    weak var navigationController: UINavigationController?
    weak var window: UIWindow?

    init(window: UIWindow?, navigationController: UINavigationController?) {
        self.window = window
        self.navigationController = navigationController
    }

    func start() {
        let loginVC: LoginViewController = .instantiate(storyboardName: LoginViewController.className)
        let viewModel = LoginViewControllerViewModel()
        loginVC.viewModel = viewModel
        loginVC.coordinator = self
        navigationController?.viewControllers = [loginVC]
        window?.rootViewController = navigationController
    }
    
    func finish() {
    }

    func goToMainScreen() {
        let mainCoordinator = MainViewControllerCoordinator(window: window,
                                                            navigationController: navigationController)
        mainCoordinator.start()
    }
    
    func goToRegisterScreen() {
        let registerCoordinator = RegisterViewControllerCoordinator(window: window,
                                                                    navigationController: navigationController)
        registerCoordinator.start()
    }
}
