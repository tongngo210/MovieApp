import UIKit

protocol WelcomeCollectionCellDelegate: AnyObject {
    func didTapButton(cell: WelcomeCollectionCell)
}

final class WelcomeCollectionCell: UICollectionViewCell {
    @IBOutlet private weak var welcomeImageView: UIImageView!
    @IBOutlet private weak var nextButton: UIButton!
    
    weak var delegate: WelcomeCollectionCellDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.delegate = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nextButton.layer.cornerRadius = nextButton.frame.height / 2
    }
    
    func configCell(page: WelcomePage) {
        welcomeImageView.image = page.image
        let customTitle = NSMutableAttributedString(string: page.buttonTitle, attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 25),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ])
        nextButton.setAttributedTitle(customTitle, for: .normal)
        nextButton.backgroundColor = AppColor.orangePeel
    }
    
    @IBAction func didTapButton(_ sender: UIButton) {
        delegate?.didTapButton(cell: self)
    }
    
}
