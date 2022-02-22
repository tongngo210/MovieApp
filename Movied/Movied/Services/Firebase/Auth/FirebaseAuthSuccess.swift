import Foundation

enum FirebaseAuthSuccess: String {
    case loginSuccess = "Login successfully"
    case logoutSuccess = "Logout successfully"
    case createNewUserSuccess = "You have created new account successfully"
    
    var title: String {
        return "Success"
    }
}
