import UIKit

final class ActorItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var actorNameLabel: UILabel!
    @IBOutlet private weak var actorImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configCell()
    }
    
    private func configCell() {
        actorImageView.layer.cornerRadius = 12
    }
    
    func fillData(with actor: Actor?) {
        actorNameLabel.text = actor?.name
        actorImageView.getImageFromURL(APIURLs.Image.original + (actor?.image ?? ""))
    }
}
