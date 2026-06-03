//
//  Colors.swift
//  MovieHub
//
//  Created by Antigravity on 03/06/26.
//

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
}
