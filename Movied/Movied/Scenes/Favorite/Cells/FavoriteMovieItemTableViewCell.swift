import UIKit

final class FavoriteMovieItemTableViewCell: UITableViewCell {

    @IBOutlet private weak var favoriteMovieBackgroundView: UIView!
    @IBOutlet private weak var favoriteMovieImageView: UIImageView!
    @IBOutlet var favoriteMovieRateStarImageViews: [UIImageView]!
    @IBOutlet private weak var favoriteMovieNameLabel: UILabel!
    @IBOutlet private weak var favoriteMovieRateLabel: UILabel!
    @IBOutlet private weak var favoriteMovieOverviewLabel: UILabel!
    
    var model: FavoriteMovieItemTableViewCellViewModel? {
        didSet {
            guard let model = model else { return }
            favoriteMovieImageView.getImageFromURL(APIURLs.Image.original + model.movieImageURLString)
            favoriteMovieNameLabel.text = model.movieNameText
            favoriteMovieRateLabel.text = "\(model.movieRateText)"
            favoriteMovieOverviewLabel.text = model.movieOverviewText
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configCell()
    }
    
    private func configCell() {
        [favoriteMovieBackgroundView, favoriteMovieImageView].forEach {
            $0.layer.cornerRadius = favoriteMovieImageView.frame.height / 10
        }
        favoriteMovieRateStarImageViews.forEach { $0.tintColor = .orange }
        favoriteMovieBackgroundView.backgroundColor = AppColor.frenchGray
        favoriteMovieOverviewLabel.layer.opacity = 0.7
    }
}
