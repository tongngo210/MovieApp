import UIKit

final class ActorItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var actorNameLabel: UILabel!
    @IBOutlet private weak var actorImageView: UIImageView!
    
    var viewModel: ActorItemCollectionViewCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            actorNameLabel.text = viewModel.actorNameText
            actorImageView.getImageFromURL(APIURLs.Image.original + viewModel.actorImageURLString)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configCell()
    }
    
    private func configCell() {
        actorImageView.layer.cornerRadius = 12
    }
}
