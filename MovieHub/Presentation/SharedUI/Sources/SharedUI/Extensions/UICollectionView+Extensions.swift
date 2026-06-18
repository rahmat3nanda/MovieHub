import UIKit

public extension UICollectionView {
    func registerCell<T: UICollectionViewCell>(_ cellClass: T.Type, bundle: Bundle? = nil) {
        let identifier = String(describing: cellClass)
        let resolvedBundle = bundle ?? .module
        register(UINib(nibName: identifier, bundle: resolvedBundle), forCellWithReuseIdentifier: identifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}

public extension UICollectionViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: reuseIdentifier, bundle: .module)
    }
}
