import UIKit

class AppCoordinator {
    
    var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        let splashCoordinator = SplashViewControllerCoordinator(window: window,
                                                                navigationController: nil)
        splashCoordinator.start()
        window?.makeKeyAndVisible()
    }
    
    func finish() {
    }
}
