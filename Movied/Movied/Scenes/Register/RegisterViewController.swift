import UIKit

final class RegisterViewController: UIViewController {
    @IBOutlet private weak var registerBackgroundImageView: UIImageView!
    @IBOutlet private weak var registerBackgroundView: UIView!
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var userNameTextField: UITextField!
    @IBOutlet private weak var userEmailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    var viewModel: RegisterViewControllerViewModel!
    var coordinator: RegisterViewControllerCoordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configViewModel()
        configView()
    }

    @IBAction func didTapRegisterButton(_ sender: UIButton) {
        let userDefaultImage = UIImage(systemName: Name.SystemImage.person)
        
        if let email = userEmailTextField.text,
           let password = passwordTextField.text,
           let userName = userNameTextField.text,
           let userDefaultImageData = userDefaultImage?.jpegData(compressionQuality: 1) {
            viewModel.createNewUser(email: email, password: password,
                                    username: userName, imageData: userDefaultImageData)
        }
    }
}
//MARK: - Configure UI, ViewModel
extension RegisterViewController {
    private func configViewModel() {
        viewModel.showAlert = { [weak self] success, title, message in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if success {
                    self.showAlertOneButton(title: title, message: message, didTapButton: { _ in
                        self.dismiss(animated: true, completion: nil)
                        self.coordinator.goToMainScreen()
                    })
                } else {
                    self.showAlertOneButton(title: title, message: message, didTapButton: nil)
                }
            }
        }
        
        viewModel.showIndicator = { [weak self] bool in
            DispatchQueue.main.async {
                self?.showIndicator(bool)
            }
        }
    }
    
    private func configView() {
        configBackgroundImageView()
        configButton()
        configTextField()
    }
    
    private func configBackgroundImageView() {
        registerBackgroundImageView.image = UIImage(named: Name.Image.registerBackground)
        registerBackgroundImageView.layer.opacity = 0.7
        
        registerBackgroundView.backgroundColor = .black.withAlphaComponent(0.6)
    }
    
    private func configButton() {
        registerButton.backgroundColor = AppColor.orangePeel
        registerButton.tintColor = .white
        registerButton.layer.cornerRadius = registerButton.frame.height / 2
    }
    
    private func configTextField() {
        [userNameTextField, userEmailTextField, passwordTextField].forEach {
            $0?.borderStyle = .none
            $0?.backgroundColor = .clear
            $0?.textColor = .white
            $0?.font = .systemFont(ofSize: 20, weight: .medium)
            $0?.autocorrectionType = .no
            $0?.spellCheckingType = .no
            $0?.returnKeyType = .done
            $0?.addDownLine()
        }
        userNameTextField.addPlaceHolder(text: Title.TextFieldPlaceHolder.name)
        userEmailTextField.addPlaceHolder(text: Title.TextFieldPlaceHolder.email)
        passwordTextField.addPlaceHolder(text: Title.TextFieldPlaceHolder.password)
        
        passwordTextField.isSecureTextEntry = true
    }
}
