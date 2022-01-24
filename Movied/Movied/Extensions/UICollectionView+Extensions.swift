import UIKit

extension UICollectionView {
    public func registerNib(cellName name: String) {
        register(UINib(nibName: name, bundle: nil),
                 forCellWithReuseIdentifier: name)
    }
    
    public func registerNib(reusableView name: String, kind: String) {
        
        register(UINib(nibName: name, bundle: nil),
                 forSupplementaryViewOfKind: kind,
                 withReuseIdentifier: name)
    }
    
    public func dequeueReusableCell<T: UICollectionViewCell>(withClass name: T.Type,
                                                             for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: String(describing: name),
                                   for: indexPath) as! T
    }
    
    public func dequeueReusableSupplementaryView<T: UICollectionReusableView>(withClass name: T.Type,
                                                                              kind: String,
                                                                              for indexPath: IndexPath) -> T {
        return dequeueReusableSupplementaryView(ofKind: kind,
                                                withReuseIdentifier: String(describing: name),
                                                for: indexPath) as! T
    }
}
