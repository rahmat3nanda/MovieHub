import UIKit
import DesignSystem
import SharedUI
import UtilityKit
import NetworkManager

public final class HomeViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.alwaysBounceVertical = true
        view.contentInsetAdjustmentBehavior = .never
        return view
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    // MARK: - Hero Banner
    private let heroContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6.withAlphaComponent(0.1)
        view.layer.masksToBounds = true
        return view
    }()
    
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "film")
        imageView.tintColor = .systemGray
        return imageView
    }()
    
    private let heroGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.clear.cgColor,
            Colors.background.withAlphaComponent(0.5).cgColor,
            Colors.background.cgColor
        ]
        gradient.locations = [0.0, 0.6, 1.0]
        return gradient
    }()
    
    private let heroTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.text = "Spider-Man: Across the Spider-Verse"
        label.numberOfLines = 2
        return label
    }()
    
    private let heroCategoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemYellow
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.text = "ACTION • ANIMATION • SCI-FI • 9.0 ★"
        return label
    }()
    
    // MARK: - Now Playing
    private let nowPlayingHeader: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.text = "Now Playing"
        return label
    }()
    
    private let nowPlayingScroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        scroll.alwaysBounceHorizontal = true
        return scroll
    }()
    
    private let nowPlayingStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fill
        return stack
    }()
    
    // MARK: - Popular Section
    private let popularHeader: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.text = "Popular Movies"
        return label
    }()
    
    private let popularScroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        scroll.alwaysBounceHorizontal = true
        return scroll
    }()
    
    private let popularStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fill
        return stack
    }()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadMovies()
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        heroGradient.frame = heroContainer.bounds
    }
    
    private func setupUI() {
        view.backgroundColor = Colors.background
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(heroContainer)
        heroContainer.addSubview(heroImageView)
        heroContainer.layer.addSublayer(heroGradient)
        heroContainer.addSubview(heroTitleLabel)
        heroContainer.addSubview(heroCategoryLabel)
        
        contentView.addSubview(nowPlayingHeader)
        contentView.addSubview(nowPlayingScroll)
        nowPlayingScroll.addSubview(nowPlayingStack)
        
        contentView.addSubview(popularHeader)
        contentView.addSubview(popularScroll)
        popularScroll.addSubview(popularStack)
        
        // Auto Layout Constraints using UtilityKit Align
        scrollView.anchors.edges.pin()
        contentView.anchors.edges.pin()
        contentView.anchors.width.equal(scrollView.anchors.width)
        
        // Hero Constraints
        heroContainer.anchors.top.pin()
        heroContainer.anchors.leading.pin()
        heroContainer.anchors.trailing.pin()
        heroContainer.anchors.height.equal(380)
        
        heroImageView.anchors.edges.pin()
        
        heroCategoryLabel.anchors.leading.pin(inset: 16)
        heroCategoryLabel.anchors.trailing.pin(inset: 16)
        heroCategoryLabel.anchors.bottom.pin(inset: 20)
        
        heroTitleLabel.anchors.leading.pin(inset: 16)
        heroTitleLabel.anchors.trailing.pin(inset: 16)
        heroTitleLabel.anchors.bottom.spacing(8, to: heroCategoryLabel.anchors.top)
        
        // Now Playing Section Constraints
        nowPlayingHeader.anchors.top.spacing(24, to: heroContainer.anchors.bottom)
        nowPlayingHeader.anchors.leading.pin(inset: 16)
        nowPlayingHeader.anchors.trailing.pin(inset: 16)
        
        nowPlayingScroll.anchors.top.spacing(12, to: nowPlayingHeader.anchors.bottom)
        nowPlayingScroll.anchors.leading.pin()
        nowPlayingScroll.anchors.trailing.pin()
        nowPlayingScroll.anchors.height.equal(220)
        
        nowPlayingStack.anchors.edges.pin(insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        nowPlayingStack.anchors.height.equal(nowPlayingScroll.anchors.height)
        
        // Popular Section Constraints
        popularHeader.anchors.top.spacing(32, to: nowPlayingScroll.anchors.bottom)
        popularHeader.anchors.leading.pin(inset: 16)
        popularHeader.anchors.trailing.pin(inset: 16)
        
        popularScroll.anchors.top.spacing(12, to: popularHeader.anchors.bottom)
        popularScroll.anchors.leading.pin()
        popularScroll.anchors.trailing.pin()
        popularScroll.anchors.height.equal(220)
        
        popularStack.anchors.edges.pin(insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        popularStack.anchors.height.equal(popularScroll.anchors.height)
        
//        contentView.anchors.bottom.equal(popularScroll.anchors.bottom).offsetting(by: 32)
    }
    
    private func loadMovies() {
        // Set Hero Mock Banner Details
        heroImageView.backgroundColor = .systemPurple.withAlphaComponent(0.2)
        heroImageView.image = UIImage(systemName: "popcorn.fill")
        
        // Mock Now Playing Movies
        let nowPlayingData = [
            ("Dune: Part Two", "Sci-Fi • 2024", "8.8", UIColor.systemOrange),
            ("Inside Out 2", "Animation • 2024", "8.5", UIColor.systemPink),
            ("Civil War", "Action • 2024", "7.6", UIColor.systemBlue),
            ("Fallout", "Sci-Fi • 2024", "8.4", UIColor.systemGreen)
        ]
        
        for movie in nowPlayingData {
            let card = MovieCardView()
            card.configure(title: movie.0, subtitle: movie.1, rating: movie.2, posterImage: nil, fallbackColor: movie.3)
            nowPlayingStack.addArrangedSubview(card)
            card.anchors.width.equal(130)
        }
        
        // Mock Popular Movies
        let popularData = [
            ("Oppenheimer", "Biography • 2023", "8.9", UIColor.systemGray),
            ("The Dark Knight", "Action • 2008", "9.0", UIColor.systemRed),
            ("Interstellar", "Sci-Fi • 2014", "8.7", UIColor.systemTeal),
            ("Inception", "Sci-Fi • 2010", "8.8", UIColor.systemYellow)
        ]
        
        for movie in popularData {
            let card = MovieCardView()
            card.configure(title: movie.0, subtitle: movie.1, rating: movie.2, posterImage: nil, fallbackColor: movie.3)
            popularStack.addArrangedSubview(card)
            card.anchors.width.equal(130)
        }
    }
}
