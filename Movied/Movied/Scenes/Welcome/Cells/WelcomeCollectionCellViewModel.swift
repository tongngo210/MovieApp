import UIKit

struct WelcomeCollectionViewCellViewModel {
    let welcomeImage: UIImage?
    let buttonTitle: String
    
    init(with model : WelcomePage) {
        welcomeImage = model.image
        buttonTitle = model.buttonTitle
    }
}
