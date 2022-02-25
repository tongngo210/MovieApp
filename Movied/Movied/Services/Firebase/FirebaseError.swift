import Foundation

enum FirebaseError: String, Error {
    //MARK: - Auth
    case authInvalidEmail = "Your email has wrong format"
    case authInvalidPassword = "Your password must at least 8 characters and have at least 1 capitalized letter"
    case authUnableToRegister = "Something went wrong with register process or your email is already in use"
    case authUnableToLogin = "Something went wrong with login process or your email hasn't been registered yet or your password is incorrect"
    case authUnableToLogout = "Something went wrong with logout process"
    //MARK: - Storage
    case storagePutDataError = "Error when saving data to storage"
    case storageGetImageURLError = "Error when get image url on storage"
    //MARK: - Firestore
    case firestoreSetDataError = "Error when saving data to firestore"
    case firestoreGetDataError = "Error when getting data from firestore"
    case firestoreEncodingDataError = "Error when get encoding Codable Object to Dictionary"
    case firestoreDecodingDataError = "Error when get decoding Dictionary to Codable Object"
    
    var title: String {
        switch self {
        case .authUnableToRegister, .authUnableToLogin, .authUnableToLogout:
            return "Something went wrong with Firebase Auth"
        case .storagePutDataError, .storageGetImageURLError:
            return "Something went wrong with Firebase Storage"
        case .firestoreSetDataError, .firestoreGetDataError,
                .firestoreEncodingDataError, .firestoreDecodingDataError:
            return "Something went wrong with Firebase Firestore"
        case .authInvalidEmail:
            return "Invalid Email Address"
        case .authInvalidPassword:
            return "Invalid Password"
        }
    }
}
