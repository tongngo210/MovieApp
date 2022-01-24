import UIKit

fileprivate var indicatorView: UIView?

extension UIViewController {
    class func instantiate<T: UIViewController>(storyboardName: String) -> T {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let identifier = String(describing: self)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
    
    func showIndicator(seconds: Double) {
        indicatorView = UIView(frame: self.view.bounds)
        indicatorView?.backgroundColor = .gray
        
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.center = indicatorView?.center ?? CGPoint()
        
        indicatorView?.addSubview(indicator)
        view.addSubview(indicatorView ?? UIView())
        
        tabBarController?.tabBar.isHidden = true
        view.isUserInteractionEnabled = false
        indicator.startAnimating()
        
        Timer.scheduledTimer(withTimeInterval: seconds, repeats: false) { [weak self] _ in
            indicator.stopAnimating()
            indicatorView?.removeFromSuperview()
            indicatorView = nil
            self?.tabBarController?.tabBar.isHidden = false
            self?.view.isUserInteractionEnabled = true
        }
    }
}
