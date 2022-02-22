import UIKit

final class LoginViewController: UIViewController {
    @IBOutlet private weak var loginBackgroundImageView: UIImageView!
    @IBOutlet private weak var loginBackgroundView: UIView!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var signupButton: UIButton!
    @IBOutlet private weak var userEmailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    var viewModel: LoginViewControllerViewModel!
    var coordinator: LoginViewControllerCoordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configViewModel()
        configView()
    }
    
    @IBAction func didTapLoginButton(_ sender: UIButton) {
        if let email = userEmailTextField.text,
           let password = passwordTextField.text {
            print(email, password)
            viewModel.login(email: email, password: password)
        }
    }
    
    @IBAction func didTapSignUpButton(_ sender: UIButton) {
        coordinator.goToRegisterScreen()
    }
}
//MARK: - Configure UI, ViewModel
extension LoginViewController {
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
        loginBackgroundImageView.image = UIImage(named: Name.Image.loginBackground)
        loginBackgroundImageView.layer.opacity = 0.7
        
        loginBackgroundView.backgroundColor = .black.withAlphaComponent(0.6)
    }
    
    private func configButton() {
        loginButton.backgroundColor = AppColor.orangePeel
        loginButton.tintColor = .white
        loginButton.layer.cornerRadius = loginButton.frame.height / 2
        
        signupButton.tintColor = AppColor.orangePeel
    }
    
    private func configTextField() {
        [userEmailTextField, passwordTextField].forEach {
            $0?.borderStyle = .none
            $0?.backgroundColor = .clear
            $0?.textColor = .white
            $0?.font = .systemFont(ofSize: 20, weight: .medium)
            $0?.autocorrectionType = .no
            $0?.spellCheckingType = .no
            $0?.returnKeyType = .done
            $0?.addDownLine()
        }
        userEmailTextField.addPlaceHolder(text: Title.TextFieldPlaceHolder.email)
        passwordTextField.addPlaceHolder(text: Title.TextFieldPlaceHolder.password)
        
        passwordTextField.isSecureTextEntry = true
    }
}
