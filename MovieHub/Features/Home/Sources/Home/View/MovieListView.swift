import UIKit
import UtilityKit
import DesignSystem

// MARK: - MovieListAppBarView

final class MovieListAppBarView: UIView {
    
    var onBackTapped: (() -> Void)?
    var onSearchTapped: (() -> Void)?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var backButton: UIButton!
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
    
    private func commonInit() {
        backgroundColor = .clear
        
        let rootNibView: UIView = loadViewFromNib(bundle: .module)
        rootNibView.fixInView(self)
        
        // Setup Button configs
        let backConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        let backImage = UIImage(systemName: "chevron.left", withConfiguration: backConfig)
        backButton.setImage(backImage, for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let searchConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        let searchImage = UIImage(systemName: "magnifyingglass", withConfiguration: searchConfig)
        searchButton.setImage(searchImage, for: .normal)
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
    }
    
    @objc private func backButtonTapped() {
        onBackTapped?()
    }
    
    @objc private func searchButtonTapped() {
        onSearchTapped?()
    }
}

// MARK: - MovieListHeaderView

final class MovieListHeaderView: UICollectionReusableView {
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(with title: String) {
        titleLabel.text = title
    }
}

// MARK: - LoadingFooterView

final class LoadingFooterView: UICollectionReusableView {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func setAnimating(_ isAnimating: Bool) {
        if isAnimating {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}

// MARK: - MovieListView

final class MovieListView: UIView {
    
    var onBackTapped: (() -> Void)?
    var onSearchTapped: (() -> Void)?
    var onRetryTapped: (() -> Void)?
    var onRefresh: (() -> Void)?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var appBar: MovieListAppBarView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var errorStack: UIStackView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    
    let refreshControl = UIRefreshControl()
    
    // MARK: - Initializer
    
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
        
        let rootNibView: UIView = loadViewFromNib(bundle: .module)
        rootNibView.fixInView(self)
        
        // Setup refresh control and callbacks
        refreshControl.addTarget(self, action: #selector(refreshTriggered), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        retryButton.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
        
        // Retry button visual setup
        retryButton.layer.borderWidth = 1
        retryButton.layer.borderColor = UIColor.systemBlue.cgColor
        retryButton.layer.cornerRadius = 6
        
        appBar.onBackTapped = { [weak self] in
            self?.onBackTapped?()
        }
        
        appBar.onSearchTapped = { [weak self] in
            self?.onSearchTapped?()
        }
    }
    
    @objc private func refreshTriggered() {
        onRefresh?()
    }
    
    @objc private func retryTapped() {
        onRetryTapped?()
    }
    
    func showEmptyState(_ show: Bool) {
        emptyLabel.isHidden = !show
        collectionView.isHidden = show
        errorStack.isHidden = true
    }
    
    func showErrorState(_ error: Error?) {
        if let error = error {
            errorLabel.text = error.localizedDescription
            errorStack.isHidden = false
            collectionView.isHidden = true
            emptyLabel.isHidden = true
        } else {
            errorStack.isHidden = true
        }
    }
    
    func showNormalState() {
        collectionView.isHidden = false
        emptyLabel.isHidden = true
        errorStack.isHidden = true
    }
}
