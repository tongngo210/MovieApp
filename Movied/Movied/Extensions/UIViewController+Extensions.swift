import UIKit

fileprivate var indicatorView: UIView?

extension UIViewController {
    class func instantiate<T: UIViewController>(storyboardName: String) -> T {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let identifier = String(describing: self)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
    
    func showIndicator(_ bool: Bool) {
        if bool {
            indicatorView = UIView(frame: self.view.bounds)
            indicatorView?.backgroundColor = .gray
            
            let indicator = UIActivityIndicatorView(style: .large)
            indicator.center = indicatorView?.center ?? CGPoint()
            
            indicatorView?.addSubview(indicator)
            view.addSubview(indicatorView ?? UIView())
            
            tabBarController?.tabBar.isHidden = true
            view.isUserInteractionEnabled = false
            indicator.startAnimating()
        } else {
            indicatorView?.removeFromSuperview()
            indicatorView = nil
            tabBarController?.tabBar.isHidden = false
            view.isUserInteractionEnabled = true
        }
    }
}
