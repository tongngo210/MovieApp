import Foundation
import FirebaseAuth

struct FirebaseAuthService {
    static let shared = FirebaseAuthService()
    
    private let auth = Auth.auth()
    
    func getCurrentUser() -> User? {
        return auth.currentUser
    }
    
    private func checkInvalidAccount(email: String, password: String,
                                     onSuccess: @escaping () -> Void,
                                     onError: @escaping (FirebaseAuthError) -> Void) {
        if !email.isValidEmail() {
            onError(.invalidEmail)
            return
        } else if !password.isValidPassword() {
            onError(.invalidPassword)
            return
        } else {
            onSuccess()
        }
    }
    
    func createNewUser(email: String, password: String,
                       completion: @escaping (Result<FirebaseAuthSuccess, FirebaseAuthError>) -> Void) {
        checkInvalidAccount(email: email, password: password) {
            auth.createUser(withEmail: email, password: password) { result, error in
                if let _ = error {
                    completion(.failure(.unableToRegister))
                    return
                }
                completion(.success(.createNewUserSuccess))
            }
        } onError: {
            completion(.failure($0))
        }
    }
    
    func login(email: String, password: String,
               completion: @escaping (Result<FirebaseAuthSuccess, FirebaseAuthError>) -> Void) {
        checkInvalidAccount(email: email, password: password) {
            auth.signIn(withEmail: email, password: password) { result, error in
                if let _ = error {
                    completion(.failure(.unableToLogin))
                    return
                }
                completion(.success(.loginSuccess))
            }
        } onError: {
            completion(.failure($0))
        }
    }
    
    func logout(completion: @escaping (Result<FirebaseAuthSuccess, FirebaseAuthError>) -> Void) {
        do {
            try auth.signOut()
            completion(.success(.logoutSuccess))
        } catch {
            completion(.failure(.unableToLogout))
        }
    }
}
