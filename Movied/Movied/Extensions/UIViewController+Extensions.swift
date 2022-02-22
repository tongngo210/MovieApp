import UIKit

fileprivate var indicatorView: UIView?

extension UIViewController {
    class func instantiate<T: UIViewController>(storyboardName: String) -> T {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let identifier = String(describing: self)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
    //MARK: - Indicator
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
    //MARK: - AlertView
    func showAlertOneButton(title: String, message: String,
                            didTapButton: ((UIAlertAction) -> Void)? ) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay",
                                      style: .default,
                                      handler: didTapButton))
        
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertTwoButton(title: String, message: String,
                            buttonTitle: String,
                            didTapButton: @escaping (UIAlertAction?) -> Void) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle,
                                      style: .default,
                                      handler: didTapButton))
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel))
        
        present(alert, animated: true, completion: nil)
    }
}
