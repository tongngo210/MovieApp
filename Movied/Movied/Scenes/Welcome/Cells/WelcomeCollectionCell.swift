import UIKit

protocol WelcomeCollectionCellDelegate: AnyObject {
    func didTapButton(cell: WelcomeCollectionCell)
}

final class WelcomeCollectionCell: UICollectionViewCell {
    @IBOutlet weak var welcomeImageView: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    
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
