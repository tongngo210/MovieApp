import UIKit

class SpinnerCircleView: UIView {
    
    let spinnerCircle = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
        let rect = self.bounds
        let circularPath = UIBezierPath(ovalIn: rect)
        
        spinnerCircle.path = circularPath.cgPath
        spinnerCircle.fillColor = UIColor.clear.cgColor
        spinnerCircle.strokeColor = AppColor.orangePeel.cgColor
        spinnerCircle.lineWidth = 5
        spinnerCircle.strokeEnd = 0.75
        spinnerCircle.lineCap = .round
        
        self.layer.addSublayer(spinnerCircle)
    }
    
    func startAnimating() {
        UIView.animate(withDuration: 1, delay: 0, options: .curveLinear) { [weak self] in
            self?.transform = CGAffineTransform(rotationAngle: .pi)
        } completion: { [weak self] _ in
            UIView.animate(withDuration: 1, delay: 0, options: .curveLinear, animations: {
                self?.transform = CGAffineTransform(rotationAngle: 0)
            }, completion: nil)
        }
    }
}
