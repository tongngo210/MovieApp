import UIKit

fileprivate let imageCache = NSCache<AnyObject, UIImage>()

extension UIImageView {
    func getImageFromURL(_ imgURL: String) {
        if let cachedImage = imageCache.object(forKey: imgURL as AnyObject) {
            DispatchQueue.main.async { [weak self] in
                self?.image = cachedImage
            }
            return
        }
        
        self.image = UIImage()
        let activityIndicator = self.activityIndicator
        
        DispatchQueue.global().async { [weak self] in
            if let url = URL(string: imgURL),
               let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                
                DispatchQueue.main.async {
                    imageCache.setObject(image, forKey: imgURL as AnyObject)
                    self?.image = image
                    activityIndicator.removeFromSuperview()
                }
            }
        }
    }
    
    private var activityIndicator: UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        let centerX = NSLayoutConstraint(item: self,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: indicator,
                                         attribute: .centerX,
                                         multiplier: 1,
                                         constant: 0)
        let centerY = NSLayoutConstraint(item: self,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: indicator,
                                         attribute: .centerY,
                                         multiplier: 1,
                                         constant: 0)
        self.addSubview(indicator)
        self.addConstraints([centerX, centerY])
        
        return indicator
    }
}
