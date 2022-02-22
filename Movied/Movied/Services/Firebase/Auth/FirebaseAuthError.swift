import Foundation

enum FirebaseAuthError: String, Error {
    case invalidEmail = "Your email has wrong format"
    case invalidPassword = "Your password must at least 8 characters and have at least 1 capitalized letter"
    case unableToRegister = "Something went wrong with register process or your email is already in use"
    case unableToLogin = "Something went wrong with login process or your email hasn't been registered yet or your password is incorrect"
    case unableToLogout = "Something went wrong with logout process"
    
    var title: String {
        switch self {
        case .invalidEmail:
            return "Invalid Email Address"
        case .invalidPassword:
            return "Invalid Password"
        case .unableToRegister, .unableToLogin, .unableToLogout:
            return "Something went wrong"
        }
    }
}
