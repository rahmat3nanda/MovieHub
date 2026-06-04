import UIKit
import UtilityKit
import DomainKit
import SharedUI

public enum SectionState {
    case loading
    case loaded([Movie])
    case empty
    case error(Error)
}

public final class MovieSectionView: UIView {
    
    // MARK: - Callbacks
    public var onRetry: (() -> Void)?
    public var onSeeAll: (() -> Void)?
    public var onSelectMovie: ((Movie) -> Void)?
    
    // MARK: - State
    public var state: SectionState = .loading {
        didSet {
            updateStateUI()
        }
    }
    
    // MARK: - UI Components
    
    private let headerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .center
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private lazy var seeAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("See All", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(seeAllTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 130, height: 220)
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.alwaysBounceHorizontal = true
        cv.dataSource = self
        cv.delegate = self
        cv.register(MovieItemCell.self, forCellWithReuseIdentifier: MovieItemCell.reuseIdentifier)
        return cv
    }()
    
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
        label.numberOfLines = 2
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
    
    // MARK: - Initializer
    
    public init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        addSubview(headerStack)
        headerStack.addArrangedSubview(titleLabel)
        headerStack.addArrangedSubview(seeAllButton)
        
        addSubview(collectionView)
        addSubview(emptyLabel)
        
        errorStack.addArrangedSubview(errorLabel)
        errorStack.addArrangedSubview(retryButton)
        addSubview(errorStack)
        
        // Auto layout using UtilityKit
        headerStack.anchors.top.pin()
        headerStack.anchors.leading.pin(inset: 16)
        headerStack.anchors.trailing.pin(inset: 16)
        
        collectionView.anchors.top.spacing(12, to: headerStack.anchors.bottom)
        collectionView.anchors.leading.pin()
        collectionView.anchors.trailing.pin()
        collectionView.anchors.bottom.pin()
        collectionView.anchors.height.equal(220)
        
        emptyLabel.anchors.center.align(with: collectionView)
        emptyLabel.anchors.leading.pin(inset: 32)
        emptyLabel.anchors.trailing.pin(inset: 32)
        
        errorStack.anchors.center.align(with: collectionView)
        errorStack.anchors.leading.pin(inset: 32)
        errorStack.anchors.trailing.pin(inset: 32)
        
        updateStateUI()
    }
    
    // MARK: - Actions
    
    @objc private func seeAllTapped() {
        onSeeAll?()
    }
    
    @objc private func retryTapped() {
        onRetry?()
    }
    
    // MARK: - State Rendering
    
    private func updateStateUI() {
        switch state {
        case .loading:
            collectionView.isHidden = false
            emptyLabel.isHidden = true
            errorStack.isHidden = true
            collectionView.reloadData()
        case .loaded(let movies):
            collectionView.isHidden = false
            emptyLabel.isHidden = true
            errorStack.isHidden = true
            collectionView.reloadData()
            
            // If list is loaded but empty, change to empty state
            if movies.isEmpty {
                state = .empty
            }
        case .empty:
            collectionView.isHidden = true
            emptyLabel.isHidden = false
            errorStack.isHidden = true
        case .error(let error):
            collectionView.isHidden = true
            emptyLabel.isHidden = true
            errorStack.isHidden = false
            errorLabel.text = error.localizedDescription
        }
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate

extension MovieSectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch state {
        case .loading:
            return 5 // Display 5 skeleton loading cards
        case .loaded(let movies):
            return movies.count
        case .empty, .error:
            return 0
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MovieItemCell.reuseIdentifier,
            for: indexPath
        ) as? MovieItemCell else {
            return UICollectionViewCell()
        }
        
        switch state {
        case .loading:
            cell.configure(with: nil, isLoading: true)
        case .loaded(let movies):
            let movie = movies[indexPath.item]
            cell.configure(with: movie, isLoading: false)
        case .empty, .error:
            break
        }
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if case .loaded(let movies) = state {
            let movie = movies[indexPath.item]
            onSelectMovie?(movie)
        }
    }
}
