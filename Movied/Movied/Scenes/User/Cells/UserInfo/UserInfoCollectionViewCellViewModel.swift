import Foundation

struct UserInfoCollectionViewCellViewModel {
    let userId: String
    let userName: String
    let userImageUrlString: String
    let likedMovies: [LikedMovie]
    
    init(user: User) {
        userId = user.userId
        userName = user.username ?? ""
        userImageUrlString = user.profileImageUrl ?? ""
        likedMovies = user.likedMovies
    }
}
