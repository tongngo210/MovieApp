import UIKit

final class FavoriteMovieItemTableViewCell: UITableViewCell {

    @IBOutlet weak var favoriteMovieBackgroundView: UIView!
    @IBOutlet weak var favoriteMovieImageView: UIImageView!
    @IBOutlet var favoriteMovieRateStarImageViews: [UIImageView]!
    @IBOutlet weak var favoriteMovieNameLabel: UILabel!
    @IBOutlet weak var favoriteMovieRateLabel: UILabel!
    @IBOutlet weak var favoriteMovieOverviewLabel: UILabel!
    
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
