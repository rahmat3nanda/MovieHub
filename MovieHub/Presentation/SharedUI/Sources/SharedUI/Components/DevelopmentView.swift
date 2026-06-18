//
//  File.swift
//  SharedUI
//
//  Created by Rahmat Trinanda Pramudya Amar on 04/06/26.
//

import DesignSystem
import UIKit
import UtilityKit
import SwiftUI

public final class DevelopmentViewController: UIViewController {
    public override func loadView() {
        view = DevelopmentView()
    }
}

public final class DevelopmentView: UIView {
    @IBOutlet private weak var iconView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = .background
        let contentView: UIView = loadViewFromNib()
        contentView.fixInView(self)
    }
}

//#Preview {
//    UIViewPreview {
//        DevelopmentView()
//    }
//}
