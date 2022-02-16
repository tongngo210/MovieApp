import UIKit

extension UIImage {
    func colored(_ color: UIColor, size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            color.set()
            self.withRenderingMode(.alwaysTemplate)
                .draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
