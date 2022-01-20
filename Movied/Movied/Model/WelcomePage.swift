import UIKit

struct WelcomePage {
    let image: UIImage
    let buttonTitle: String
    
    static var welcomePages: [WelcomePage] {
        return [WelcomePage(image: UIImage(named: Name.Image.welcome1) ?? UIImage(), buttonTitle: Title.Button.next),
                WelcomePage(image: UIImage(named: Name.Image.welcome2) ?? UIImage(), buttonTitle: Title.Button.next),
                WelcomePage(image: UIImage(named: Name.Image.welcome3) ?? UIImage(), buttonTitle: Title.Button.getStarted)]
    }
}
