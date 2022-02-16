import UIKit

protocol WelcomeCollectionCellDelegate: AnyObject {
    func didTapButton(cell: WelcomeCollectionCell)
}

final class WelcomeCollectionCell: UICollectionViewCell {
    @IBOutlet private weak var welcomeImageView: UIImageView!
    @IBOutlet private weak var nextButton: UIButton!
    
    var viewModel: WelcomeCollectionViewCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            welcomeImageView.image = viewModel.welcomeImage
            let customTitle = NSMutableAttributedString(string: viewModel.buttonTitle, attributes: [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 25),
                NSAttributedString.Key.foregroundColor: UIColor.white
            ])
            nextButton.setAttributedTitle(customTitle, for: .normal)
        }
    }
    weak var delegate: WelcomeCollectionCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configCell()
    }
    
    private func configCell() {
        nextButton.layer.cornerRadius = nextButton.frame.height / 2
        nextButton.backgroundColor = AppColor.orangePeel
    }
    
    @IBAction func didTapButton(_ sender: UIButton) {
        delegate?.didTapButton(cell: self)
    }
}
