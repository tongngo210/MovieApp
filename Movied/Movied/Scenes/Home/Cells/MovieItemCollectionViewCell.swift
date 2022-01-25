import UIKit

final class MovieItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet private weak var movieNameLabel: UILabel!
    @IBOutlet private weak var movieRateView: UIView!
    @IBOutlet private weak var movieRateLabel: UILabel!
    
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
    
    func fillData(with movie: Movie?) {
        movieImageView.getImageFromURL(APIURLs.Image.original + (movie?.poster ?? ""))
        movieNameLabel.text = movie?.title
        movieRateLabel.text = "\(movie?.voteRate ?? 0)"
    }
}
