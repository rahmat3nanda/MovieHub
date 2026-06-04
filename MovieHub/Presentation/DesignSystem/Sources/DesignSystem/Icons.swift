//
//  Icons.swift
//  MovieHub
//
//  Created by Antigravity on 03/06/26.
//

import UIKit

public enum Icons {
    /// `Icon.pdf`
    public static var icon: UIImage { .from(named: "Icon") }
}

fileprivate extension UIImage {
    static func from(named: String) -> UIImage {
        UIImage(named: named, in: Bundle.module, compatibleWith: nil) ?? UIImage()
    }
}
