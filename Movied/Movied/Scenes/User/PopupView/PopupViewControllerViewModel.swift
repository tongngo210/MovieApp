import Foundation

final class PopupViewControllerViewModel {
    
    var showAlert: ((Bool, String, String) -> ())?
    
    func userLogOut() {
        FirebaseAuthService.shared.logout { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let result):
                self.showAlert?(true, result.title, result.rawValue)
            case .failure(let error):
                self.showAlert?(false, error.title, error.rawValue)
            }
        }
    }
}
