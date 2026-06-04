import UIKit
import UtilityKit
import DesignSystem

// MARK: - MovieListAppBarView

final class MovieListAppBarView: UIView {
    
    var onBackTapped: (() -> Void)?
    var onSearchTapped: (() -> Void)?
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        let image = UIImage(systemName: "chevron.left", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
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
        addSubview(searchButton)
        
        backButton.anchors.leading.pin(inset: 8)
        backButton.anchors.centerY.align()
        backButton.anchors.size.equal(CGSize(width: 44, height: 44))
        
        titleLabel.anchors.center.align(with: self)
        
        searchButton.anchors.trailing.pin(inset: 16)
        searchButton.anchors.centerY.align()
        searchButton.anchors.size.equal(CGSize(width: 44, height: 44))
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
    static let reuseIdentifier = "MovieListHeaderView"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.anchors.leading.pin(inset: 16)
        titleLabel.anchors.trailing.pin(inset: 16)
        titleLabel.anchors.top.pin(inset: 12)
        titleLabel.anchors.bottom.pin(inset: 8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
}

// MARK: - LoadingFooterView

final class LoadingFooterView: UICollectionReusableView {
    static let reuseIdentifier = "LoadingFooterView"
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(activityIndicator)
        activityIndicator.anchors.center.align()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    let appBar = MovieListAppBarView()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = true
        cv.alwaysBounceVertical = true
        return cv
    }()
    
    let refreshControl = UIRefreshControl()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "No movies found."
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 3
        return label
    }()
    
    private lazy var retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Retry", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
        button.setTitleColor(.systemBlue, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.cornerRadius = 6
        button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16)
        button.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
        return button
    }()
    
    private let errorStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .center
        stack.isHidden = true
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configUI()
    }
    
    private func configUI() {
        backgroundColor = .background
        
        refreshControl.addTarget(self, action: #selector(refreshTriggered), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        addSubview(appBar)
        addSubview(collectionView)
        addSubview(emptyLabel)
        
        errorStack.addArrangedSubview(errorLabel)
        errorStack.addArrangedSubview(retryButton)
        addSubview(errorStack)
        
        appBar.anchors.top.pin(to: safeAreaLayoutGuide)
        appBar.anchors.leading.pin()
        appBar.anchors.trailing.pin()
        appBar.anchors.height.equal(56)
        
        collectionView.anchors.top.spacing(0, to: appBar.anchors.bottom)
        collectionView.anchors.leading.pin()
        collectionView.anchors.trailing.pin()
        collectionView.anchors.bottom.pin()
        
        emptyLabel.anchors.center.align(with: collectionView)
        emptyLabel.anchors.leading.pin(inset: 32)
        emptyLabel.anchors.trailing.pin(inset: 32)
        
        errorStack.anchors.center.align(with: collectionView)
        errorStack.anchors.leading.pin(inset: 32)
        errorStack.anchors.trailing.pin(inset: 32)
        
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
