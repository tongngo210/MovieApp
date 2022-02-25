import UIKit

protocol UserInfoCollectionViewCellDelegate: NSObject {
    func didTapSetting()
}

final class UserInfoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var userBackgroundView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var appLogoImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userLikeQuantityLabel: UILabel!
    
    weak var delegate: UserInfoCollectionViewCellDelegate?
    
    var viewModel: UserInfoCollectionViewCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            userImageView.getImageFromURL(viewModel.userImageUrlString)
            userNameLabel.text = viewModel.userName
            userLikeQuantityLabel.text = "\(viewModel.likedMovies.count)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configCell()
    }

    private func configCell() {
        userBackgroundView.backgroundColor = AppColor.orangePeel
        appLogoImageView.image = UIImage(named: Name.Image.halfMovieLogo)
        
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
        userImageView.contentMode = .scaleToFill
    }
    
    @IBAction func didTapSettingButton(_ sender: UIButton) {
        delegate?.didTapSetting()
    }
}
