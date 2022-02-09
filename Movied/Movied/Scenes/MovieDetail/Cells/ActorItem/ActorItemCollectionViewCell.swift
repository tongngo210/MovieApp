import UIKit

final class ActorItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var actorNameLabel: UILabel!
    @IBOutlet weak var actorImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configCell()
    }
    
    private func configCell() {
        actorImageView.layer.cornerRadius = 12
    }
}
