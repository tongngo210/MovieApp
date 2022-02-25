import Foundation
import FirebaseFirestore

struct FirebaseFirestoreService {
    static let shared = FirebaseFirestoreService()
    
    static private let database = Firestore.firestore()
    
    private let usersDoc = database.collection("users")
    //MARK: - User
    func saveProfile(userId: String, email: String,
                     imageData: Data, username: String,
                     completion: @escaping (Result<Void, FirebaseError>) -> Void) {
        let userDocUsingUserId = usersDoc.document(userId)
        //Save User Profile Image to Storage and get the URL
        FirebaseStorageService.shared.saveAndGetUserImageURLString(userId: userId,
                                                                   imageData: imageData) { result in
            switch result {
            case .success(let userImageURLString):
                
                let newUser = User(userId: userId, email: email, username: username,
                                   profileImageUrl: userImageURLString, likedMovies: [])
                
                do {
                    let userJson = try newUser.toDictionary()
                    userDocUsingUserId.setData(userJson) { error in
                        if let _ = error {
                            completion(.failure(.firestoreSetDataError))
                        }
                    }
                } catch {
                    completion(.failure(.firestoreEncodingDataError))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
            completion(.success(()))
        }
    }
    
    func getUserProfile(userId: String,
                        completion: @escaping (Result<User, FirebaseError>) -> Void) {
        usersDoc.document(userId).addSnapshotListener { querySnapshot, error in
            if let _ = error {
                completion(.failure(.firestoreGetDataError))
            } else {
                guard let dictionary = querySnapshot?.data() else { return }
                do {
                    let data = try JSONSerialization.data(withJSONObject: dictionary)
                    let user = try JSONDecoder().decode(User.self, from: data)
                    completion(.success(user))
                } catch {
                    completion(.failure(.firestoreDecodingDataError))
                }
            }
        }
    }
    //MARK: - Like Movie
    func likeMovie(_ bool: Bool, userId: String, likedMovie: LikedMovie,
                   completion: @escaping (Result<Void, FirebaseError>) -> Void) {
        do {
            let likedMovieDict = try likedMovie.toDictionary()
            if bool {
                usersDoc.document(userId).updateData(
                    [ Name.Firebase.Firestore.likedMoviesFile:
                        FieldValue.arrayUnion( [likedMovieDict] ) ]
                )
            } else {
                usersDoc.document(userId).updateData(
                    [ Name.Firebase.Firestore.likedMoviesFile:
                        FieldValue.arrayRemove( [likedMovieDict] ) ]
                )
            }
        } catch {
            completion(.failure(.firestoreEncodingDataError))
        }
    }
}
