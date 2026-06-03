//
//  UIView+Extension.swift
//  UtilityKit
//
//  Created by Rahmat Trinanda Pramudya Amar on 04/06/26.
//

import UIKit

public extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
}
