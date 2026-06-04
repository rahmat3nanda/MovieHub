import UIKit
import UtilityKit

public final class SkeletonView: UIView {
    private let gradientLayer = CAGradientLayer()
    
    public init(baseColor: UIColor, highlightColor: UIColor, cornerRadius: CGFloat) {
        super.init(frame: .zero)
        self.backgroundColor = baseColor
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        
        gradientLayer.colors = [
            baseColor.cgColor,
            highlightColor.cgColor,
            baseColor.cgColor
        ]
        gradientLayer.locations = [-1.0, -0.5, 0.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        layer.addSublayer(gradientLayer)
        
        startShimmeringAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    private func startShimmeringAnimation() {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.duration = 1.5
        animation.repeatCount = .infinity
        animation.isRemovedOnCompletion = false
        gradientLayer.add(animation, forKey: "shimmerAnimation")
    }
}

public extension UIView {
    private struct AssociatedKeys {
        static var skeletonViewKey = "skeletonViewKey"
        static var isSkeletonableKey = "isSkeletonableKey"
    }
    
    public var isSkeletonable: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.isSkeletonableKey) as? Bool ?? true
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.isSkeletonableKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// Shows a skeleton view with a shimmering effect on the view.
    /// - Parameters:
    ///   - baseColor: The base background color of the skeleton. Defaults to a subtle system gray.
    ///   - highlightColor: The highlight color of the shimmer gradient. Defaults to a lighter system gray.
    ///   - cornerRadius: The corner radius of the skeleton view. Defaults to 8.
    ///   - recursive: If true, searches all leaf subviews (like UILabel, UIImageView, UIButton) and overlays skeletons on them individually.
    func showSkeleton(
        baseColor: UIColor = .systemGray6,
        highlightColor: UIColor = .systemGray5,
        cornerRadius: CGFloat = 8,
        recursive: Bool = false
    ) {
        if recursive {
            let leaves = findSkeletonableViews(in: self)
            for leaf in leaves {
                leaf.showSkeleton(
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                    cornerRadius: cornerRadius,
                    recursive: false
                )
            }
            return
        }
        
        // Ensure we don't stack multiple skeletons on the same view
        hideSkeleton(recursive: false)
        
        let skeleton = SkeletonView(
            baseColor: baseColor,
            highlightColor: highlightColor,
            cornerRadius: cornerRadius
        )
        
        addSubview(skeleton)
        
        // Use UtilityKit Align anchors to pin to superview
        skeleton.anchors.edges.pin()
        
        objc_setAssociatedObject(
            self,
            &AssociatedKeys.skeletonViewKey,
            skeleton,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
    }
    
    /// Hides the skeleton view if it is present.
    /// - Parameter recursive: If true, recursively hides skeletons on all subviews.
    func hideSkeleton(recursive: Bool = false) {
        if recursive {
            let leaves = findSkeletonableViews(in: self)
            for leaf in leaves {
                leaf.hideSkeleton(recursive: false)
            }
            return
        }
        
        if let skeleton = objc_getAssociatedObject(self, &AssociatedKeys.skeletonViewKey) as? UIView {
            skeleton.removeFromSuperview()
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.skeletonViewKey,
                nil,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    private func findSkeletonableViews(in view: UIView) -> [UIView] {
        guard view.isSkeletonable else { return [] }
        
        var leaves: [UIView] = []
        
        // Standard view elements that represent final leaf nodes for content
        if view is UILabel || view is UIImageView || view is UIButton {
            leaves.append(view)
        } else if view.subviews.isEmpty {
            leaves.append(view)
        } else {
            for subview in view.subviews where !(subview is SkeletonView) {
                leaves.append(contentsOf: findSkeletonableViews(in: subview))
            }
        }
        return leaves
    }
}
