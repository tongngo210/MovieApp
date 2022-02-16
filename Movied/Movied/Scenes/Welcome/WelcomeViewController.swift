import UIKit

final class WelcomeViewController: UIViewController {
    @IBOutlet private weak var welcomeCollectionView: UICollectionView!
    @IBOutlet private weak var pageControl: UIPageControl!
    
    var viewModel: WelcomeViewControllerViewModel!
    var coordinator: WelcomeViewControllerCoordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configViewModel()
        configView()
    }
}
//MARK: - Configure UI
extension WelcomeViewController {
    private func configViewModel() {
        viewModel.reloadCollectionView = { [weak self] in
            DispatchQueue.main.async {
                self?.welcomeCollectionView.reloadData()
            }
        }
    }
    
    private func configView() {
        configCollectionView()
        configPageControl()
    }
    
    private func configPageControl() {
        pageControl.numberOfPages = viewModel.numberOfWelcomePageCells
    }
    
    private func configCollectionView() {
        welcomeCollectionView.isPagingEnabled = true
        welcomeCollectionView.delegate = self
        welcomeCollectionView.dataSource = self
        welcomeCollectionView.registerNib(cellName: WelcomeCollectionCell.className)
    }
}
//MARK: - WelcomeCollectionCell Delegate
extension WelcomeViewController: WelcomeCollectionCellDelegate {
    func didTapButton(cell: WelcomeCollectionCell) {
        guard let indexPathItem = welcomeCollectionView.indexPath(for: cell)?.item
        else { return }
        
        if indexPathItem < viewModel.numberOfWelcomePageCells - 1 {
            let nextIndexPath = IndexPath(item: indexPathItem + 1, section: 0)
            welcomeCollectionView.scrollToItem(at: nextIndexPath,
                                               at: .centeredHorizontally,
                                               animated: true)
            pageControl.currentPage += 1
        } else {
            coordinator.goToMainScreen()
        }
    }
}
//MARK: - Collection View Delegate, Datasource
extension WelcomeViewController: UICollectionViewDelegate,
                                 UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfWelcomePageCells
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: WelcomeCollectionCell.self,
                                                      for: indexPath)
        if 0..<viewModel.numberOfWelcomePageCells ~= indexPath.row {
            let cellViewModel = viewModel.getWelcomePageCellViewModel(at: indexPath)
            cell.viewModel = cellViewModel
            cell.delegate = self
        }
        
        return cell
    }
}
//MARK: - Collection View Flow Layout
extension WelcomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: view.frame.width,
                          height: collectionView.frame.height)
        return size
    }
}
//MARK: - Scroll View
extension WelcomeViewController {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        pageControl.currentPage = pageNumber
    }
}
