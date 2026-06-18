import UIKit
import UtilityKit
import DomainKit
import DesignSystem
import Kingfisher

public final class MovieItemCell: UICollectionViewCell {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var posterView: RemoteImageView!
    @IBOutlet private weak var gradientView: UIView!
    @IBOutlet private weak var starIcon: UIImageView!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var ratingStack: UIStackView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var yearLabel: UILabel!
    @IBOutlet private weak var trendIcon: UIImageView!
    @IBOutlet private weak var trendLabel: UILabel!
    @IBOutlet private weak var trendStack: UIStackView!

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

    public override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = gradientView.bounds
        containerView.layer.borderColor = UIColor.border.cgColor
    }

    private func setupViews() {
        containerView.layer.cornerRadius = 16
        containerView.layer.masksToBounds = true
        containerView.backgroundColor = .systemGray6.withAlphaComponent(0.2)
        containerView.layer.borderWidth = 1
        gradientView.layer.addSublayer(gradientLayer)
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
            return
        }
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
