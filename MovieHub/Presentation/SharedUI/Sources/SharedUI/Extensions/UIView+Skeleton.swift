import UIKit
import UtilityKit
import DesignSystem

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
    
    private static var defaultBaseColor: UIColor {
        return UIColor(white: 0.12, alpha: 1.0)
    }

    private static var defaultHighlightColor: UIColor {
        return UIColor(white: 0.22, alpha: 1.0)
    }
    
    var isSkeletonable: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.isSkeletonableKey) as? Bool ?? true
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.isSkeletonableKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// Shows a skeleton view with a shimmering effect on the view.
    /// - Parameters:
    ///   - baseColor: The base background color of the skeleton.
    ///   - highlightColor: The highlight color of the shimmer gradient.
    ///   - cornerRadius: The corner radius of the skeleton view. Defaults to 8.
    ///   - recursive: If true, searches all leaf subviews and overlays skeletons on them.
    func showSkeleton(
        baseColor: UIColor? = nil,
        highlightColor: UIColor? = nil,
        cornerRadius: CGFloat = 8,
        recursive: Bool = false
    ) {
        let resolvedBase = baseColor ?? Self.defaultBaseColor
        let resolvedHighlight = highlightColor ?? Self.defaultHighlightColor

        if recursive {
            let leaves = findSkeletonableViews(in: self)
            for leaf in leaves {
                leaf.showSkeleton(
                    baseColor: resolvedBase,
                    highlightColor: resolvedHighlight,
                    cornerRadius: cornerRadius,
                    recursive: false
                )
            }
            return
        }
        
        // Ensure we don't stack multiple skeletons on the same view
        hideSkeleton(recursive: false)
        
        let skeleton = SkeletonView(
            baseColor: resolvedBase,
            highlightColor: resolvedHighlight,
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
        let activeSubviews = view.subviews.filter { !($0 is SkeletonView) }
        
        // UIStackView and UIScrollView are structural containers, always recurse their subviews
        if view is UIStackView || view is UIScrollView {
            for subview in activeSubviews {
                leaves.append(contentsOf: findSkeletonableViews(in: subview))
            }
        } else if view is UILabel || view is UIImageView || view is UIButton {
            leaves.append(view)
        } else if activeSubviews.isEmpty {
            leaves.append(view)
        } else {
            for subview in activeSubviews {
                leaves.append(contentsOf: findSkeletonableViews(in: subview))
            }
        }
        return leaves
    }
}
