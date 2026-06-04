import UIKit
import UtilityKit
import DesignSystem

final class HomeAppBarView: UIView {
    
    // MARK: - Callbacks
    var onSearchTapped: (() -> Void)?
    
    // MARK: - UI Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "MovieHub"
        label.textColor = .secondary
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        let image = UIImage(systemName: "magnifyingglass", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        backgroundColor = .clear
        
        addSubview(titleLabel)
        addSubview(searchButton)
        
        // Layout using UtilityKit anchors
        titleLabel.anchors.center.align(with: self)
        
        searchButton.anchors.trailing.pin(inset: 16)
        searchButton.anchors.centerY.align()
        searchButton.anchors.size.equal(CGSize(width: 44, height: 44))
    }
    
    // MARK: - Actions
    
    @objc private func searchButtonTapped() {
        onSearchTapped?()
    }
}
