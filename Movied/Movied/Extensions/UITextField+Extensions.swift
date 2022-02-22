import UIKit

extension UITextField {
    func addDownLine() {
        let view = UIView(frame: CGRect(x: 0, y: frame.maxY,
                                        width: frame.width, height: 2))
        view.backgroundColor = AppColor.frenchGray
        addSubview(view)
    }
    
    func addPlaceHolder(text: String) {
        attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)]
        )
    }
}
