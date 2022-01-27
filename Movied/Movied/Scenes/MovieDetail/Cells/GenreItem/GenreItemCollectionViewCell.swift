import UIKit

final class GenreItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var genreNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configCell()
    }
    
    private func configCell() {
        genreNameLabel.textColor = .gray
    }
    
    func fillData(with genre: Genre?) {
        genreNameLabel.text = genre?.name
    }
}
