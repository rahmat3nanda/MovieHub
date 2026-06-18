import UIKit

extension UIView {
    func loadViewFromNib<T: UIView>(bundle: Bundle = .module) -> T {
        guard let nibName = type(of: self).description().components(separatedBy: ".").last else {
            fatalError("NIB not found")
        }

        let nib = UINib(nibName: nibName, bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? T else {
            fatalError("NIB cannot be loaded")
        }

        return view
    }

    func fixInView(_ container: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        frame = container.bounds
        container.addSubview(self)
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: container.topAnchor),
            bottomAnchor.constraint(equalTo: container.bottomAnchor),
            leadingAnchor.constraint(equalTo: container.leadingAnchor),
            trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])
    }
}
