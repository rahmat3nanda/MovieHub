import UIKit
import UtilityKit
import DesignSystem

final class HomeAppBarView: UIView {
    
    // MARK: - Callbacks
    var onSearchTapped: (() -> Void)?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    // MARK: - Setup
    
    private func commonInit() {
        backgroundColor = .clear
        
        let rootNibView: UIView = loadViewFromNib(bundle: .module)
        rootNibView.fixInView(self)
        
        // Setup Button config
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        let image = UIImage(systemName: "magnifyingglass", withConfiguration: config)
        searchButton.setImage(image, for: .normal)
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func searchButtonTapped() {
        onSearchTapped?()
    }
}
