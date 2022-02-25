import UIKit

final class PopupViewController: UIViewController {

    @IBOutlet private weak var backgroundPopupView: UIView!
    @IBOutlet private weak var logOutButton: UIButton!
    @IBOutlet private weak var closeButton: UIButton!
    
    var viewModel: PopupViewControllerViewModel!
    var coordinator: PopupViewControllerCoordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configViewModel()
        configView()
    }
    
    @IBAction func didTapLogOutButton(_ sender: UIButton) {
        viewModel.userLogOut()
    }
    
    @IBAction func didTapCloseButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
//MARK: - Configure UI
extension PopupViewController {
    private func configView() {
        view.backgroundColor = .clear
        backgroundPopupView.backgroundColor = AppColor.orangePeel
    }
    
    private func configViewModel() {
        viewModel.showAlert = { [weak self] success, title, message in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if success {
                    self.showAlertOneButton(title: title, message: message, didTapButton: { _ in
                        self.dismiss(animated: true, completion: nil)
                        self.coordinator.goToLogin()
                    })
                } else {
                    self.showAlertOneButton(title: title, message: message, didTapButton: nil)
                }
            }
        }
    }
}
