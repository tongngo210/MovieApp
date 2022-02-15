import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        let isNewUser = UserDefaults.standard.bool(forKey: AppKey.UserDefault.checkNewUser)
        if isNewUser {
            let welcomeVC = WelcomeViewController.instantiate(storyboardName: WelcomeViewController.className)
            window?.rootViewController = welcomeVC
        } else {
            let mainVC = MainViewController.instantiate(storyboardName: MainViewController.className)
            window?.rootViewController = mainVC
        }
        
        window?.makeKeyAndVisible()
    }
}
