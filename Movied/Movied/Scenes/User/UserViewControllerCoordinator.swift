import UIKit

class UserViewControllerCoordinator: Coordinator {
    weak var navigationController: UINavigationController?
    var window: UIWindow?
    
    init(window: UIWindow?, navigationController: UINavigationController?) {
        self.window = window
        self.navigationController = navigationController
    }

    func start() {
        let currentUserId = FirebaseAuthService.shared.getCurrentUserId()
        
        let userVC: UserViewController = .instantiate(storyboardName: UserViewController.className)
        let viewModel = UserViewControllerViewModel(userId: currentUserId)
        userVC.viewModel = viewModel
        userVC.coordinator = self

        navigationController?.pushViewController(userVC, animated: true)
    }

    func finish() {
    }
    
    func showPopUpView() {
        let popupCoordinator = PopupViewControllerCoordinator(window: window, navigationController: navigationController)
        popupCoordinator.start()
    }
}
