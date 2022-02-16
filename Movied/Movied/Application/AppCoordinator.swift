import UIKit

class AppCoordinator {
    
    var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
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
        window?.makeKeyAndVisible()
    }
    
    func finish() {
    }
}
