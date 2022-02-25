import UIKit

final class LikedMovieItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var likedMovieImageView: UIImageView!
    
    var viewModel: LikedMovieItemCollectionViewCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            likedMovieImageView.getImageFromURL(viewModel.movieImageURLString)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configCell()
    }

    private func configCell() {
        likedMovieImageView.layer.cornerRadius = 10
    }
    
}
