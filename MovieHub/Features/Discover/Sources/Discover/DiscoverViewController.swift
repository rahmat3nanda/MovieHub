import UIKit
import DesignSystem
import SharedUI
import UtilityKit

public final class DiscoverViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.text = "Discover"
        return label
    }()
    
    // MARK: - Search Container
    private let searchContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6.withAlphaComponent(0.15)
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.08).cgColor
        return view
    }()
    
    private let searchIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.tintColor = .secondaryLabel
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let searchTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Search movies, genres, actors..."
        field.textColor = .label
        field.font = .systemFont(ofSize: 15)
        field.attributedPlaceholder = NSAttributedString(
            string: "Search movies, genres, actors...",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel]
        )
        return field
    }()
    
    // MARK: - Categories Section
    private let tagsHeader: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.text = "Popular Categories"
        return label
    }()
    
    private let tagsScroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        scroll.alwaysBounceHorizontal = true
        return scroll
    }()
    
    private let tagsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fill
        return stack
    }()
    
    // MARK: - Results Grid
    private let resultsHeader: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.text = "Explore Movies"
        return label
    }()
    
    private let resultsScroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.alwaysBounceVertical = true
        return scroll
    }()
    
    private let resultsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fill
        return stack
    }()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadCategories()
        loadGridResults()
    }
    
    private func setupUI() {
        view.backgroundColor = Colors.background
        
        view.addSubview(titleLabel)
        view.addSubview(searchContainer)
        searchContainer.addSubview(searchIcon)
        searchContainer.addSubview(searchTextField)
        
        view.addSubview(tagsHeader)
        view.addSubview(tagsScroll)
        tagsScroll.addSubview(tagsStack)
        
        view.addSubview(resultsHeader)
        view.addSubview(resultsScroll)
        resultsScroll.addSubview(resultsStack)
        
        // Auto Layout Constraints using UtilityKit Align
        titleLabel.anchors.top.pin(to: view.safeAreaLayoutGuide.topAnchor, inset: 16)
        titleLabel.anchors.leading.pin(inset: 16)
        titleLabel.anchors.trailing.pin(inset: 16)
        
        // Search bar
        searchContainer.anchors.top.spacing(16, to: titleLabel.anchors.bottom)
        searchContainer.anchors.leading.pin(inset: 16)
        searchContainer.anchors.trailing.pin(inset: 16)
        searchContainer.anchors.height.equal(50)
        
        searchIcon.anchors.leading.pin(inset: 16)
        searchIcon.anchors.centerY.align()
        searchIcon.anchors.size.equal(CGSize(width: 20, height: 20))
        
        searchTextField.anchors.leading.spacing(12, to: searchIcon.anchors.trailing)
        searchTextField.anchors.trailing.pin(inset: 16)
        searchTextField.anchors.top.pin()
        searchTextField.anchors.bottom.pin()
        
        // Tags
        tagsHeader.anchors.top.spacing(24, to: searchContainer.anchors.bottom)
        tagsHeader.anchors.leading.pin(inset: 16)
        tagsHeader.anchors.trailing.pin(inset: 16)
        
        tagsScroll.anchors.top.spacing(12, to: tagsHeader.anchors.bottom)
        tagsScroll.anchors.leading.pin()
        tagsScroll.anchors.trailing.pin()
        tagsScroll.anchors.height.equal(38)
        
        tagsStack.anchors.edges.pin(insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        tagsStack.anchors.height.equal(tagsScroll.anchors.height)
        
        // Grid Results
        resultsHeader.anchors.top.spacing(24, to: tagsScroll.anchors.bottom)
        resultsHeader.anchors.leading.pin(inset: 16)
        resultsHeader.anchors.trailing.pin(inset: 16)
        
        resultsScroll.anchors.top.spacing(12, to: resultsHeader.anchors.bottom)
        resultsScroll.anchors.leading.pin()
        resultsScroll.anchors.trailing.pin()
        resultsScroll.anchors.bottom.pin(to: view.safeAreaLayoutGuide.bottomAnchor)
        
        resultsStack.anchors.edges.pin(insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        resultsStack.anchors.width.equal(resultsScroll.anchors.width - 32)
    }
    
    private func loadCategories() {
        let genres = ["All", "Action", "Sci-Fi", "Comedy", "Drama", "Thriller", "Horror", "Romance"]
        for (index, genre) in genres.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(genre, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            button.layer.cornerRadius = 10
            button.layer.masksToBounds = true
            
            if index == 0 {
                // Active State (All)
                button.backgroundColor = .systemYellow
                button.setTitleColor(.black, for: .normal)
            } else {
                // Inactive State
                button.backgroundColor = .systemGray6.withAlphaComponent(0.15)
                button.setTitleColor(.label, for: .normal)
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.white.withAlphaComponent(0.08).cgColor
            }
            
            tagsStack.addArrangedSubview(button)
            button.anchors.height.equal(34)
        }
    }
    
    private func loadGridResults() {
        // We will mock rows with pairs of cards side by side
        let results = [
            (
                "Avatar: The Way of Water", "Sci-Fi • 2022", "7.6", UIColor.systemBlue,
                "The Batman", "Action • 2022", "7.8", UIColor.systemRed
            ),
            (
                "Everything Everywhere", "Sci-Fi • 2022", "8.0", UIColor.systemPink,
                "Top Gun: Maverick", "Action • 2022", "8.3", UIColor.systemYellow
            ),
            (
                "Spider-Man: No Way Home", "Action • 2021", "8.2", UIColor.systemPurple,
                "Dune", "Sci-Fi • 2021", "8.0", UIColor.systemOrange
            )
        ]
        
        for row in results {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.spacing = 16
            rowStack.distribution = .fillEqually
            
            let card1 = MovieCardView()
            card1.configure(title: row.0, subtitle: row.1, rating: row.2, posterImage: nil, fallbackColor: row.3)
            rowStack.addArrangedSubview(card1)
            
            let card2 = MovieCardView()
            card2.configure(title: row.4, subtitle: row.5, rating: row.6, posterImage: nil, fallbackColor: row.7)
            rowStack.addArrangedSubview(card2)
            
            resultsStack.addArrangedSubview(rowStack)
            rowStack.anchors.height.equal(220)
        }
    }
}
