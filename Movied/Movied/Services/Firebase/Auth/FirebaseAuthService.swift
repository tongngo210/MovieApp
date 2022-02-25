import Foundation
import FirebaseAuth

struct FirebaseAuthService {
    static let shared = FirebaseAuthService()
    
    private let auth = Auth.auth()
    
    func getCurrentUserId() -> String {
        return auth.currentUser?.uid ?? ""
    }
    
    private func checkInvalidAccount(email: String, password: String,
                                     completion: @escaping (Result<Void, FirebaseError>) -> Void) {
        if !email.isValidEmail() {
            completion(.failure(.authInvalidEmail))
            return
        } else if !password.isValidPassword() {
            completion(.failure(.authInvalidPassword))
            return
        } else {
            completion(.success(()))
        }
    }
    
    func createNewUser(email: String, password: String,
                       username: String, imageData: Data,
                       completion: @escaping (Result<FirebaseAuthSuccess, FirebaseError>) -> Void) {
        checkInvalidAccount(email: email, password: password) { result in
            switch result {
            case .success():
                //Create New User to Auth
                auth.createUser(withEmail: email, password: password) { result, error in
                    if let _ = error {
                        completion(.failure(.authUnableToRegister))
                        return
                    }
                    guard let userId = result?.user.uid else { return }
                    //Save User Profile to Firestore
                    FirebaseFirestoreService.shared
                        .saveProfile(userId: userId, email: email,
                                     imageData: imageData, username: username) { result in
                            switch result {
                            case .success():
                                completion(.success(.createNewUserSuccess))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func login(email: String, password: String,
               completion: @escaping (Result<FirebaseAuthSuccess, FirebaseError>) -> Void) {
        checkInvalidAccount(email: email, password: password) { result in
            switch result {
            case .success():
                //Sign in User to Auth
                auth.signIn(withEmail: email, password: password) { result, error in
                    if let _ = error {
                        completion(.failure(.authUnableToLogin))
                        return
                    }
                    completion(.success(.loginSuccess))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func logout(completion: @escaping (Result<FirebaseAuthSuccess, FirebaseError>) -> Void) {
        do {
            try auth.signOut()
            completion(.success(.logoutSuccess))
        } catch {
            completion(.failure(.authUnableToLogout))
        }
    }
}
