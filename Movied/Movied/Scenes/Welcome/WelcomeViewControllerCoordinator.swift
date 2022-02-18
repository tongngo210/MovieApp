import UIKit

class WelcomeViewControllerCoordinator: Coordinator {
    weak var navigationController: UINavigationController?
    weak var window: UIWindow?
    
    init(window: UIWindow?, navigationController: UINavigationController?) {
        self.window = window
        self.navigationController = navigationController
    }
    
    func start() {
        let welcomeVC: WelcomeViewController = .instantiate(storyboardName: WelcomeViewController.className)
        let viewModel = WelcomeViewControllerViewModel()
        welcomeVC.viewModel = viewModel
        welcomeVC.coordinator = self
        window?.rootViewController = welcomeVC
    }
    
    func finish() {
    }
    
    func goToMainScreen() {
        if let window = window {
            let mainCoordinator = MainViewControllerCoordinator(window: window,
                                                  navigationController: nil)
            mainCoordinator.start()
            UIView.transition(with: window,
                              duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
            window.makeKeyAndVisible()
        }
    }
}
