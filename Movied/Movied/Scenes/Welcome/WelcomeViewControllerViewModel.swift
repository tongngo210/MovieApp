import Foundation

final class WelcomeViewControllerViewModel {
    
    var reloadCollectionView: (()->())?
    
    private (set) var welcomeCellViewModels = [WelcomeCollectionViewCellViewModel]() {
        didSet {
            self.reloadCollectionView?()
        }
    }
    
    init() {
        createWelcomePageCellViewModels()
    }
    
//MARK: - Welcome Cells
    private func createWelcomePageCellViewModels() {
        var cellViewModels = [WelcomeCollectionViewCellViewModel]()
        for page in WelcomePage.welcomePages {
            cellViewModels.append(WelcomeCollectionViewCellViewModel(with: page))
        }
        self.welcomeCellViewModels = cellViewModels
    }
    
    var numberOfWelcomePageCells: Int {
        return welcomeCellViewModels.count
    }
    
    func getWelcomePageCellViewModel(at indexPath: IndexPath) -> WelcomeCollectionViewCellViewModel {
        return welcomeCellViewModels[indexPath.item]
    }
}
