import Foundation

struct Name {
    static let persistantContainer = "CoredataFavoriteMovie"
    struct Image {
        static let movieLogo = "movieLogo"
        static let halfMovieLogo = "halfMovieLogo"
        static let welcome1 = "Welcome1"
        static let welcome2 = "Welcome2"
        static let welcome3 = "Welcome3"
        static let placeholder = "movieLogo"
        static let loginBackground = "loginBackground"
        static let registerBackground = "registerBackground"
        static let trash = "trash"
        static let liked = "liked"
        static let unliked = "unliked"
    }
    struct SystemImage {
        static let filledStar = "star.fill"
        static let unfilledStar = "star"
        static let halfStar = "star.leadinghalf.filled"
        static let person = "person"
        static let house = "house"
    }
    struct Firebase {
        struct Storage {
            static let metaDataContentType = "image/jpg"
            static let userImageFile = "userImage"
        }
        struct Firestore {
            static let likedMoviesFile = "likedMovies"
        }
    }
}
