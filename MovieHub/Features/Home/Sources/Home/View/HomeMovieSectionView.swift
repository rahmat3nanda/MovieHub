import UIKit
import UtilityKit
import DomainKit
import SharedUI
import DesignSystem

public enum HomeSectionState {
    case loading
    case loaded([Movie])
    case empty
    case error(Error)
}

final class HomeMovieSectionView: UIView {
    
    // MARK: - Callbacks
    var onRetry: (() -> Void)?
    var onSeeAll: (() -> Void)?
    var onSelectMovie: ((Movie) -> Void)?
    
    // MARK: - State
    var state: HomeSectionState = .loading {
        didSet {
            updateStateUI()
        }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var headerStack: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var seeAllButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var errorStack: UIStackView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    
    // MARK: - Initializers
    
    init(title: String) {
        super.init(frame: .zero)
        commonInit()
        setTitle(title)
    }
    
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
        let rootNibView: UIView = loadViewFromNib(bundle: .module)
        rootNibView.fixInView(self)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerCell(MovieItemCell.self)
        
        seeAllButton.addTarget(self, action: #selector(seeAllTapped), for: .touchUpInside)
        retryButton.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
        
        // Retry button visual setup
        retryButton.layer.borderWidth = 1
        retryButton.layer.borderColor = UIColor.systemBlue.cgColor
        retryButton.layer.cornerRadius = 6
        
        updateStateUI()
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
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
        // Guard against outlets being nil during early init
        guard collectionView != nil else { return }
        
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

extension HomeMovieSectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch state {
        case .loading:
            return 5 // Display 5 skeleton loading cards
        case .loaded(let movies):
            return movies.count
        case .empty, .error:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MovieItemCell = collectionView.dequeueReusableCell(for: indexPath)
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if case .loaded(let movies) = state {
            let movie = movies[indexPath.item]
            onSelectMovie?(movie)
        }
    }
}
