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
        let spinnerIndicator = self.spinnerIndicator
        
        DispatchQueue.global().async { [weak self] in
            if let url = URL(string: imgURL),
               let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                
                DispatchQueue.main.async {
                    imageCache.setObject(image, forKey: imgURL as AnyObject)
                    self?.image = image
                    spinnerIndicator.removeFromSuperview()
                }
            } else {
                DispatchQueue.main.async {
                    self?.image = UIImage(named: Name.Image.placeholder)
                    spinnerIndicator.removeFromSuperview()
                }
            }
        }
    }
    
    private var spinnerIndicator: SpinnerCircleView {
        let spinnerIndicator = SpinnerCircleView()
        spinnerIndicator.center = self.center
        DispatchQueue.main.async {
            spinnerIndicator.startAnimating()
        }
        self.addSubview(spinnerIndicator)
        return spinnerIndicator
    }
}
