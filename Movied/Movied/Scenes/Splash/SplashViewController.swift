import UIKit

final class SplashViewController: UIViewController {

    var coordinator: SplashViewControllerCoordinator!
    
    @IBOutlet private weak var movieLogoImageView: UIImageView!
    @IBOutlet private weak var appNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        startAnimating()
    }
    
    private func configView() {
        appNameLabel.text = ""
        appNameLabel.textColor = .white
    }
    
    private func startAnimating() {
        UIView.animate(withDuration: 1.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: { [weak self] in
            self?.movieLogoImageView.center.y = self?.view.bounds.height ?? 0 - 50
        }) { [weak self] _ in
            var index = 0.0
            for letter in Title.app.uppercased() {
                Timer.scheduledTimer(withTimeInterval: 0.2 * index, repeats: false) { _ in
                    self?.appNameLabel.text?.append(letter)
                }
                index += 1
            }
            
            UIView.animate(withDuration: 1, delay: 2.5, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                self?.appNameLabel.center.y = (self?.view.center.y ?? 0) - 10
            }) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.coordinator.goToFirstScreen()
                }
            }
        }
    }
}
