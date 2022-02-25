import Foundation
import FirebaseStorage

struct FirebaseStorageService {
    static let shared = FirebaseStorageService()
    
    static private let storage = Storage.storage().reference()
    private let storageUserImage = storage.child(Name.Firebase.Storage.userImageFile)
    
    func saveAndGetUserImageURLString(userId: String, imageData: Data,
                                      completion: @escaping (Result<String, FirebaseError>) -> Void) {
        let storageUserImageOfUserId = storageUserImage.child(userId)
        let storageMetaData = StorageMetadata()
        storageMetaData.contentType = Name.Firebase.Storage.metaDataContentType
        //Save Image Data to Storage
        storageUserImageOfUserId.putData(imageData,
                                         metadata: storageMetaData) { _, error in
            if let _ = error {
                completion(.failure(.storagePutDataError))
                return
            }
            //Get the Image URL from Storage
            storageUserImageOfUserId.downloadURL { url, error in
                if let _ = error {
                    completion(.failure(.storageGetImageURLError))
                }
                
                if let profileImageUrl = url?.absoluteString {
                    completion(.success(profileImageUrl))
                }
            }
        }
    }
}
