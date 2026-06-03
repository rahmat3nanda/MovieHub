//
//  Icons.swift
//  MovieHub
//
//  Created by Antigravity on 03/06/26.
//

import UIKit

public enum Icons {
    /// `Icon.pdf`
    public static var icon: UIImage {
        return UIImage(named: "Icon", in: Bundle.module, compatibleWith: nil) ?? UIImage()
    }
}
