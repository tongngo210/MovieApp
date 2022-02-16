import UIKit

final class GenreItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var genreNameLabel: UILabel!
    
    var viewModel: GenreItemCollectionViewCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            genreNameLabel.text = viewModel.genreNameText
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configCell()
    }
    
    private func configCell() {
        genreNameLabel.textColor = .gray
    }
}
