import UIKit

class PopupViewControllerCoordinator: Coordinator {
    var navigationController: UINavigationController?
    var window: UIWindow?
    
    init(window: UIWindow?, navigationController: UINavigationController?) {
        self.window = window
        self.navigationController = navigationController
    }
    
    func start() {
        let popupVC: PopupViewController = .instantiate(storyboardName: PopupViewController.className)
        let viewModel = PopupViewControllerViewModel()
        popupVC.viewModel = viewModel
        popupVC.coordinator = self
        
        navigationController?.present(popupVC, animated: true, completion: nil)
    }
    
    func finish() {
    }

    func goToLogin() {
        if let window = window {
            let loginCoordinator = LoginViewControllerCoordinator(window: window,
                                                                  navigationController: navigationController)
            loginCoordinator.start()
            UIView.transition(with: window,
                              duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
            window.makeKeyAndVisible()
        }
    }
}
