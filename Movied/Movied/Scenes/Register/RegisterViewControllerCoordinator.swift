import UIKit

class RegisterViewControllerCoordinator: Coordinator {
    weak var navigationController: UINavigationController?
    weak var window: UIWindow?

    init(window: UIWindow?, navigationController: UINavigationController?) {
        self.window = window
        self.navigationController = navigationController
    }

    func start() {
        let registerVC: RegisterViewController = .instantiate(storyboardName: RegisterViewController.className)
        let viewModel = RegisterViewControllerViewModel()
        registerVC.viewModel = viewModel
        registerVC.coordinator = self
        navigationController?.present(registerVC, animated: true, completion: nil)
    }
    
    func finish() {
    }

    func goToMainScreen() {
        let mainCoordinator = MainViewControllerCoordinator(window: window,
                                                            navigationController: navigationController)
        mainCoordinator.start()
    }
}
