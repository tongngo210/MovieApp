import UIKit

class UserViewControllerCoordinator: Coordinator {
    weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func start() {
        let userVC: UserViewController = .instantiate(storyboardName: UserViewController.className)
        let viewModel = UserViewControllerViewModel()
        userVC.viewModel = viewModel
        userVC.coordinator = self

        navigationController?.pushViewController(userVC, animated: true)
    }

    func finish() {
    }
}
