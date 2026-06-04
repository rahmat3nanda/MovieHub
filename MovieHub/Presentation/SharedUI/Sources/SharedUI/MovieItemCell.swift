import UIKit
import UtilityKit
import DomainKit
import DesignSystem
import Kingfisher

public final class MovieItemCell: UICollectionViewCell {
    public static let reuseIdentifier = "MovieItemCell"
    
    // MARK: - UI Components
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.backgroundColor = .systemGray6.withAlphaComponent(0.2)
        return view
    }()
    
    private let posterView: RemoteImageView = {
        let imageView = RemoteImageView()
        return imageView
    }()
    
    private let gradientView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.5).cgColor,
            UIColor.black.withAlphaComponent(0.95).cgColor
        ]
        gradient.locations = [0.0, 0.4, 1.0]
        return gradient
    }()
    
    private let starIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")
        // Nice amber yellow color for the star
        imageView.tintColor = UIColor(red: 245/255, green: 158/255, blue: 11/255, alpha: 1.0)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private let ratingStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 6
        stack.alignment = .center
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 13, weight: .medium)
        return label
    }()
    
    private let trendIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "arrow.up.right")
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let trendLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 13, weight: .medium)
        return label
    }()
    
    private let trendStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        return stack
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = gradientView.bounds
    }
    
    // MARK: - Setup Views
    
    private func setupViews() {
        contentView.addSubview(containerView)
        containerView.anchors.edges.pin()
        
        containerView.addSubview(posterView)
        posterView.anchors.edges.pin()
        
        containerView.addSubview(gradientView)
        gradientView.layer.addSublayer(gradientLayer)
        gradientView.anchors.leading.pin()
        gradientView.anchors.trailing.pin()
        gradientView.anchors.bottom.pin()
        gradientView.anchors.height.equal(containerView.anchors.height * 0.6)
        
        ratingStack.addArrangedSubview(starIcon)
        ratingStack.addArrangedSubview(ratingLabel)
        
        trendStack.addArrangedSubview(trendIcon)
        trendStack.addArrangedSubview(trendLabel)
        
        containerView.addSubview(ratingStack)
        containerView.addSubview(titleLabel)
        containerView.addSubview(yearLabel)
        containerView.addSubview(trendStack)
        
        // Layout constraints using UtilityKit Align anchors
        starIcon.anchors.size.equal(CGSize(width: 14, height: 14))
        trendIcon.anchors.size.equal(CGSize(width: 12, height: 12))
        
        ratingStack.anchors.leading.pin(inset: 12)
        ratingStack.anchors.trailing.pin(inset: 12)
        ratingStack.anchors.bottom.spacing(6, to: titleLabel.anchors.top)
        
        titleLabel.anchors.leading.pin(inset: 12)
        titleLabel.anchors.trailing.pin(inset: 12)
        titleLabel.anchors.bottom.spacing(8, to: yearLabel.anchors.top)
        
        yearLabel.anchors.leading.pin(inset: 12)
        yearLabel.anchors.bottom.pin(inset: 12)
        
        trendStack.anchors.trailing.pin(inset: 12)
        trendStack.anchors.bottom.pin(inset: 12)
    }
    
    // MARK: - Configuration
    
    /// Configures the cell with a movie entity and its loading state.
    /// - Parameters:
    ///   - movie: The movie entity to display.
    ///   - isLoading: If true, overlays a shimmering skeleton over text and images.
    public func configure(with movie: Movie?, isLoading: Bool) {
        if isLoading {
            // Set text placeholders so skeleton outlines are correctly sized
            ratingLabel.text = "0.0"
            titleLabel.text = "Loading Movie Title\nPlaceholder Content"
            yearLabel.text = "2026"
            trendLabel.text = "100%"
            
            // Hide icons and gradient background to make the skeleton effect clean
            starIcon.alpha = 0
            trendIcon.alpha = 0
            gradientView.alpha = 0
            
            // Clear poster view and cancel any pending downloads
            posterView.loadImage(from: nil)
            
            // Show skeleton recursively on all leaf content elements
            containerView.showSkeleton(recursive: true)
        } else {
            // Remove skeleton from all subviews
            containerView.hideSkeleton(recursive: true)
            
            starIcon.alpha = 1
            trendIcon.alpha = 1
            gradientView.alpha = 1
            
            guard let movie = movie else { return }
            
            titleLabel.text = movie.title
            ratingLabel.text = String(format: "%.1f", movie.voteAverage)
            
            // Format year (extract from YYYY-MM-DD)
            if let year = movie.releaseDate.split(separator: "-").first {
                yearLabel.text = String(year)
            } else {
                yearLabel.text = movie.releaseDate
            }
            
            // Calculate trend percentage linearly based on voteAverage to match reference:
            // 8.9 voteAverage -> 98% trend
            // 7.5 voteAverage -> 82% trend
            let percentage = min(100, Int(movie.voteAverage * 11))
            trendLabel.text = "\(percentage)%"
            
            // Fetch and cache poster image using RemoteImageView
            if let posterPath = movie.posterPath {
                let posterURL = "https://image.tmdb.org/t/p/w500\(posterPath)"
                posterView.loadImage(from: posterURL)
            } else {
                posterView.loadImage(from: nil)
            }
        }
    }
}
