import UIKit

final class MovieItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var movieRateView: UIView!
    @IBOutlet weak var movieRateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configCell()
    }

    private func configCell() {
        movieRateView.layer.cornerRadius = movieRateView.frame.height / 2
        movieImageView.layer.cornerRadius = 6
        movieRateView.backgroundColor = AppColor.orangePeel
        movieRateLabel.textColor = .white
    }
}
