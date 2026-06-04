import UIKit

public extension UIColor {
    /// `Background` = `#111415`
    static var background: UIColor {
        return UIColor(named: "Background", in: Bundle.module, compatibleWith: nil) ?? .systemBackground
    }
    
    /// `Secondary` = `#6366F1`
    static var secondary: UIColor {
        return UIColor(named: "Secondary", in: Bundle.module, compatibleWith: nil) ?? .white
    }
    
    /// `Border` = white alpha 0.15
    static var border: UIColor {
        return UIColor(named: "Border", in: Bundle.module, compatibleWith: nil) ?? .separator
    }
}
