import Foundation

final class UserViewControllerViewModel {
    private (set) var userId: String?
    
    private (set) var userInfoCellViewModel: UserInfoCollectionViewCellViewModel?
    private (set) var likedMoviesCellViewModels: [LikedMovieItemCollectionViewCellViewModel] = []
    
    var reloadCollectionView: (() -> ())?
    var showIndicator: ((Bool) -> ())?
    
    init(userId: String) {
        self.userId = userId
        fetchUserInfoData()
    }
    //MARK: - Firebase Firestore
    func fetchUserInfoData() {
        showIndicator?(true)
        if let userId = userId {
            FirebaseFirestoreService.shared.getUserProfile(userId: userId) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let user):
                    self.userInfoCellViewModel = UserInfoCollectionViewCellViewModel(user: user)
                    self.createLikedMoviesCellViewModels(from: user.likedMovies)
                    self.reloadCollectionView?()
                case .failure(let error):
                    print(error.rawValue)
                }
                self.showIndicator?(false)
            }
            
        }
    }
    //MARK: - User Info Cell
    func getUserInfoCellViewModel() -> UserInfoCollectionViewCellViewModel? {
        return userInfoCellViewModel
    }
    
    //MARK: - Liked Movie Cell
    private func createLikedMoviesCellViewModels(from movies: [LikedMovie]) {
        var viewModels = [LikedMovieItemCollectionViewCellViewModel]()
        for movie in movies {
            viewModels.append(LikedMovieItemCollectionViewCellViewModel(likedMovie: movie))
        }
        likedMoviesCellViewModels = viewModels
    }

    var numberOfAllLikedMovieCells: Int {
        return likedMoviesCellViewModels.count
    }

    func getLikedMovieCellViewModel(at indexPath: IndexPath) -> LikedMovieItemCollectionViewCellViewModel {
        return likedMoviesCellViewModels[indexPath.row - 1]
    }
}
