import UIKit
import DesignSystem
import UtilityKit

final class MovieDetailAppBarView: UIView {

    var onBackTapped: (() -> Void)?
    var onShareTapped: (() -> Void)?

    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
        button.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "MovieHub"
        label.textColor = .secondary
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        return label
    }()

    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        button.setImage(UIImage(systemName: "square.and.arrow.up", withConfiguration: config), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .clear
        addSubview(backButton)
        addSubview(titleLabel)
        addSubview(shareButton)

        backButton.anchors.leading.pin(inset: 16)
        backButton.anchors.centerY.align()
        backButton.anchors.size.equal(CGSize(width: 40, height: 40))

        titleLabel.anchors.center.align(with: self)

        shareButton.anchors.trailing.pin(inset: 16)
        shareButton.anchors.centerY.align()
        shareButton.anchors.size.equal(CGSize(width: 40, height: 40))
    }

    @objc private func backTapped() { onBackTapped?() }
    @objc private func shareTapped() { onShareTapped?() }
}
