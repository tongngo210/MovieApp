import UIKit

final class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
}
//MARK: - Configure UI
extension MainViewController {
    func configView() {
        configTabbar()
    }
    
    func configTabbar() {
        tabBar.tintColor = AppColor.orangePeel
    }
}
