import Foundation

final class LoginViewControllerViewModel {
    
    var showIndicator: ((Bool) -> ())?
    var showAlert: ((Bool, String, String) -> ())?
    
    func login(email: String, password: String) {
        showIndicator?(true)
        FirebaseAuthService.shared.login(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            self.showIndicator?(false)
            switch result {
            case .success(let result):
                self.showAlert?(true, result.title, result.rawValue)
            case .failure(let error):
                self.showAlert?(false, error.title, error.rawValue)
            }
        }
    }
}
