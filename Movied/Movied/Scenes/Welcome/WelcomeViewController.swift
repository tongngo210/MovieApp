import UIKit

final class WelcomeViewController: UIViewController {
    @IBOutlet private weak var welcomeCollectionView: UICollectionView!
    @IBOutlet private weak var pageControl: UIPageControl!
    
    private let welcomePages = WelcomePage.welcomePages
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
}
//MARK: - Configure UI
extension WelcomeViewController {
    private func configView() {
        configCollectionView()
        configPageControl()
    }
    
    private func configPageControl() {
        pageControl.numberOfPages = welcomePages.count
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
        guard let indexPathItem = welcomeCollectionView.indexPath(for: cell)?.item,
              let appWindow = UIApplication.shared.keyWindow
        else { return }
        
        if indexPathItem < welcomePages.count - 1 {
            let nextIndexPath = IndexPath(item: indexPathItem + 1, section: 0)
            welcomeCollectionView.scrollToItem(at: nextIndexPath,
                                               at: .centeredHorizontally,
                                               animated: true)
            pageControl.currentPage += 1
        } else {
            let mainVC = MainViewController.instantiate(storyboardName: MainViewController.className)
            
            appWindow.rootViewController = mainVC
            appWindow.makeKeyAndVisible()
            UIView.transition(with: appWindow,
                              duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
        }
    }
}
//MARK: - Collection View Delegate, Datasource
extension WelcomeViewController: UICollectionViewDelegate,
                                 UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return welcomePages.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: WelcomeCollectionCell.self,
                                                      for: indexPath)
        if welcomePages.indices ~= indexPath.row {
            cell.delegate = self
            cell.configCell(page: welcomePages[indexPath.row])
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
