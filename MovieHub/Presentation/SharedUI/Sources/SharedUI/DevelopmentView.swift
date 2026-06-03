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
    public override func viewDidLoad() {
        super.viewDidLoad()
        view = DevelopmentView()
    }
}

public final class DevelopmentView: UIView {

    private lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.left.forwardslash.chevron.right")
        imageView.tintColor = .secondary
        imageView.contentMode = .scaleAspectFit

        imageView.anchors.width.equal(64)
        imageView.anchors.height.equal(64)

        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Under Development"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .secondary
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "We're currently behind the scenes building a personalized cinematic home for you. " +
        "Soon you'll be able to manage your watchlist, track history, and customize your experience."
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configUI()
    }
}

private extension DevelopmentView {
    private func configUI() {
        backgroundColor = .background

        addSubviews([iconView, titleLabel, descriptionLabel])
        titleLabel.anchors.center.align()
        iconView.anchors.bottom.equal(titleLabel.anchors.top, constant: -24)
        iconView.anchors.centerX.align()
        descriptionLabel.anchors.top.equal(titleLabel.anchors.bottom, constant: 16)
        descriptionLabel.anchors.leading.equal(anchors.leading, constant: 16)
        descriptionLabel.anchors.trailing.equal(anchors.trailing, constant: -16)
    }
}

#Preview {
    UIViewPreview {
        DevelopmentView()
    }
}
