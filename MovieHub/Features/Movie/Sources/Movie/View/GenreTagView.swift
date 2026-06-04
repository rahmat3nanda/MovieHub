import UIKit
import DesignSystem
import UtilityKit

final class GenreTagView: UIView {

    private let label: UILabel = {
        let textLabel = UILabel()
        textLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        textLabel.textColor = .secondary
        textLabel.textAlignment = .center
        return textLabel
    }()

    init(name: String) {
        super.init(frame: .zero)
        backgroundColor = UIColor.secondary.withAlphaComponent(0.15)
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.secondary.withAlphaComponent(0.4).cgColor
        addSubview(label)
        label.text = name
        label.anchors.edges.pin(insets: UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
