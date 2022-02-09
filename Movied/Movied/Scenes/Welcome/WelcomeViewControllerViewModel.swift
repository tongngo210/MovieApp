import Foundation

final class WelcomeViewControllerViewModel {
    
    var reloadCollectionView: (()->())?
    
    private (set) var welcomeCellViewModels = [WelcomeCollectionViewCellViewModel]() {
        didSet {
            self.reloadCollectionView?()
        }
    }
    
    init() {
        createWelcomePageCells()
    }
    
//MARK: - Welcome Cells
    private func createWelcomePageCells() {
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
