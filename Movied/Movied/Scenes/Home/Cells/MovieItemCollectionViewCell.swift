import UIKit

final class MovieItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet private weak var movieNameLabel: UILabel!
    @IBOutlet private weak var movieRateView: UIView!
    @IBOutlet private weak var movieRateLabel: UILabel!
    
    var viewModel: MovieItemCollectionViewCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            movieImageView.getImageFromURL(APIURLs.Image.original + viewModel.movieImageURLString)
            movieNameLabel.text = viewModel.movieNameText
            movieRateLabel.text = "\(viewModel.movieRateText)"
        }
    }
    
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
