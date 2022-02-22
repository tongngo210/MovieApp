import Foundation

final class RegisterViewControllerViewModel {
    
    var showIndicator: ((Bool) -> ())?
    var showAlert: ((Bool, String, String) -> ())?
    
    func createNewUser(email: String, password: String) {
        showIndicator?(true)
        FirebaseAuthService.shared.createNewUser(email: email, password: password) { [weak self] result in
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