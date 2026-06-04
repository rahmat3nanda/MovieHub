import UIKit
import DesignSystem
import UtilityKit

final class StatBadgeView: UIView {

    private let iconView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.tintColor = UIColor(red: 245/255, green: 158/255, blue: 11/255, alpha: 1)
        return view
    }()

    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .white
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .medium)
        label.textColor = .systemGray
        return label
    }()

    private let stack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .center
        return stackView
    }()

    // swiftlint:disable:next function_default_parameter_at_end
    init(icon: String, value: String, subtitle: String, iconTintColor: UIColor? = nil) {
        super.init(frame: .zero)
        let resolvedTint = iconTintColor ?? UIColor(red: 245/255, green: 158/255, blue: 11/255, alpha: 1)
        iconView.image = UIImage(systemName: icon)
        iconView.tintColor = resolvedTint
        valueLabel.text = value
        subtitleLabel.text = subtitle

        backgroundColor = UIColor.white.withAlphaComponent(0.06)
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.border.cgColor

        let iconRow = UIStackView(arrangedSubviews: [iconView, valueLabel])
        iconRow.axis = .horizontal
        iconRow.spacing = 4
        iconRow.alignment = .center
        iconView.anchors.size.equal(CGSize(width: 16, height: 16))

        stack.addArrangedSubview(iconRow)
        stack.addArrangedSubview(subtitleLabel)

        addSubview(stack)
        stack.anchors.edges.pin(insets: UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(value: String) {
        valueLabel.text = value
    }
}
