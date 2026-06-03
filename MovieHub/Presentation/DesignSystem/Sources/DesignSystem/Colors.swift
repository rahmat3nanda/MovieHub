//
//  Colors.swift
//  MovieHub
//
//  Created by Antigravity on 03/06/26.
//

import UIKit

public enum Colors {
    /// `Background` = `#111415`
    public static var background: UIColor {
        return UIColor(named: "Background", in: Bundle.module, compatibleWith: nil) ?? .systemBackground
    }
}
