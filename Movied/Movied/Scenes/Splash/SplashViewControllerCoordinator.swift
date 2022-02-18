import UIKit

class SplashViewControllerCoordinator: Coordinator {
    weak var navigationController: UINavigationController?
    weak var window: UIWindow?
    
    init(window: UIWindow?, navigationController: UINavigationController?) {
        self.window = window
        self.navigationController = navigationController
    }
    
    func start() {
        let splashVC: SplashViewController = .instantiate(storyboardName: SplashViewController.className)
        splashVC.coordinator = self
        window?.rootViewController = splashVC
    }
    
    func finish() {
    }
    
    func goToFirstScreen() {
        if let window = window {
            let isNewUser = UserDefaults.standard.bool(forKey: AppKey.UserDefault.checkNewUser)
            if isNewUser {
                let welcomeCoordinator = WelcomeViewControllerCoordinator(window: window,
                                                                          navigationController: nil)
                welcomeCoordinator.start()
            } else {
                let mainCoordinator = MainViewControllerCoordinator(window: window,
                                                                    navigationController: nil)
                mainCoordinator.start()
            }
            UIView.transition(with: window,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
            window.makeKeyAndVisible()
        }
    }
}
