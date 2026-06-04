import UIKit
import DomainKit
import DesignSystem
import SharedUI
import UtilityKit

// MARK: - MovieDetailView

public final class MovieDetailView: UIView {

    // MARK: - Callbacks

    var onBackTapped: (() -> Void)?
    var onShareTapped: (() -> Void)?
    var onRetryTapped: (() -> Void)?
    var onRefresh: (() -> Void)?
    var onLoadMoreReviews: (() -> Void)?

    // MARK: - App Bar

    let appBar = MovieDetailAppBarView()

    let appBarBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.background.withAlphaComponent(0.85)
        return view
    }()

    var backdropTopConstraint: NSLayoutConstraint?
    var backdropHeightConstraint: NSLayoutConstraint?

    // MARK: - Scroll & Content

    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.alwaysBounceVertical = true
        sv.contentInsetAdjustmentBehavior = .never
        return sv
    }()

    lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.tintColor = .secondary
        rc.addTarget(self, action: #selector(refreshTriggered), for: .valueChanged)
        return rc
    }()

    let contentView = UIView()

    // MARK: - Hero Backdrop

    let backdropImageView: RemoteImageView = {
        let iv = RemoteImageView()
        iv.layer.cornerRadius = 0
        iv.clipsToBounds = true
        return iv
    }()

    let backdropGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor(red: 17/255, green: 20/255, blue: 21/255, alpha: 1).cgColor
        ]
        gradient.locations = [0.3, 1.0]
        return gradient
    }()

    let backdropOverlay: UIView = {
        let view = UIView()
        return view
    }()

    // MARK: - Poster

    let posterImageView: RemoteImageView = {
        let iv = RemoteImageView()
        iv.layer.cornerRadius = 16
        iv.clipsToBounds = true
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.border.cgColor
        iv.backgroundColor = .background
        return iv
    }()

    // MARK: - Title Area

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()

    let taglineLabel: UILabel = {
        let label = UILabel()
        label.font = .italicSystemFont(ofSize: 14)
        label.textColor = UIColor.systemGray
        label.numberOfLines = 2
        return label
    }()

    // MARK: - Stats Row

    let ratingBadge = StatBadgeView(icon: "star.fill", value: "0.0", subtitle: "Rating")
    let runtimeBadge = StatBadgeView(icon: "clock.fill", value: "--", subtitle: "Runtime", iconTintColor: .secondary)
    let yearBadge = StatBadgeView(
        icon: "calendar",
        value: "----",
        subtitle: "Year",
        iconTintColor: UIColor(red: 52/255, green: 211/255, blue: 153/255, alpha: 1)
    )

    let statsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fillEqually
        return stack
    }()

    // MARK: - Genres

    let genreScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsHorizontalScrollIndicator = false
        sv.alwaysBounceHorizontal = true
        return sv
    }()

    let genreStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()

    // MARK: - Overview

    let overviewSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Overview"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        return label
    }()

    let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.white.withAlphaComponent(0.75)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    // MARK: - Reviews

    let reviewsSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Reviews"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        return label
    }()

    let reviewsLoadingIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .medium)
        ai.color = .secondary
        ai.hidesWhenStopped = true
        return ai
    }()

    let reviewsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        return stack
    }()

    let noReviewsLabel: UILabel = {
        let label = UILabel()
        label.text = "No reviews yet."
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    let paginationLoadingIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .medium)
        ai.color = .secondary
        ai.hidesWhenStopped = true
        return ai
    }()

    // MARK: - Error & Loading States

    let errorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .systemRed
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
    }()

    lazy var retryButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Retry", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        btn.setTitleColor(.secondary, for: .normal)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.secondary.cgColor
        btn.layer.cornerRadius = 8
        btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20)
        btn.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
        return btn
    }()

    let errorStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .center
        stack.isHidden = true
        return stack
    }()

    let loadingIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .large)
        ai.color = .secondary
        ai.hidesWhenStopped = true
        return ai
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        backdropGradient.frame = backdropOverlay.bounds

        let topPadding = safeAreaInsets.top + 56
        if scrollView.contentInset.top != topPadding {
            scrollView.contentInset = UIEdgeInsets(top: topPadding, left: 0, bottom: 0, right: 0)
            scrollView.scrollIndicatorInsets = scrollView.contentInset

            backdropTopConstraint?.constant = -topPadding
            backdropHeightConstraint?.constant = 280 + topPadding
        }
    }
}

// MARK: - Configuration

extension MovieDetailView {

    func configure(with movie: Movie) {
        loadingIndicator.stopAnimating()
        errorStack.isHidden = true
        scrollView.isHidden = false

        contentView.hideSkeleton(recursive: true)

        if let backdrop = movie.backdropPath {
            backdropImageView.loadImage(from: "https://image.tmdb.org/t/p/w780\(backdrop)", placeholder: nil)
        } else if let poster = movie.posterPath {
            backdropImageView.loadImage(from: "https://image.tmdb.org/t/p/w780\(poster)", placeholder: nil)
        }

        if let poster = movie.posterPath {
            posterImageView.loadImage(from: "https://image.tmdb.org/t/p/w500\(poster)")
        }

        titleLabel.text = movie.title

        if let tagline = movie.tagline, !tagline.isEmpty {
            taglineLabel.text = "\"\(tagline)\""
            taglineLabel.isHidden = false
        } else {
            taglineLabel.isHidden = true
        }

        ratingBadge.update(value: String(format: "%.1f", movie.voteAverage))

        if let runtime = movie.runtime, runtime > 0 {
            let hours = runtime / 60
            let minutes = runtime % 60
            runtimeBadge.update(value: hours > 0 ? "\(hours)h \(minutes)m" : "\(minutes)m")
        } else {
            runtimeBadge.update(value: "N/A")
        }

        if let year = movie.releaseDate.split(separator: "-").first {
            yearBadge.update(value: String(year))
        } else {
            yearBadge.update(value: movie.releaseDate)
        }

        overviewLabel.text = movie.overview.isEmpty ? "No overview available." : movie.overview

        genreStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        if let genres = movie.genres, !genres.isEmpty {
            genres.forEach { genre in
                genreStack.addArrangedSubview(GenreTagView(name: genre.name))
            }
        }
    }

    func configureReviews(with state: MovieReviewsUIState) {
        switch state {
        case .loading:
            reviewsLoadingIndicator.startAnimating()
            noReviewsLabel.isHidden = true
            reviewsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

            for i in 0..<3 {
                let card = ReviewCardView()
                let dummyDetails = MovieReviewAuthorDetails(name: "Author Name", username: "username", avatarPath: nil, rating: 8.0)
                let dummyReview = MovieReview(
                    id: "dummy_review_\(i)",
                    author: "Review Author Name",
                    authorDetails: dummyDetails,
                    content: "This is a placeholder review content paragraph. " +
                             "It will be covered by skeleton lines so it simulates the loaded review look.",
                    createdAt: "2026-06-04",
                    updatedAt: "2026-06-04",
                    url: ""
                )
                card.configure(with: dummyReview)
                reviewsStack.addArrangedSubview(card)
                card.showSkeleton(recursive: true)
            }

        case .loaded(let reviews):
            reviewsLoadingIndicator.stopAnimating()
            reviewsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
            noReviewsLabel.isHidden = true

            reviews.forEach { review in
                let card = ReviewCardView()
                card.configure(with: review)
                reviewsStack.addArrangedSubview(card)
            }

        case .empty:
            reviewsLoadingIndicator.stopAnimating()
            reviewsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
            noReviewsLabel.isHidden = false

        case .error:
            reviewsLoadingIndicator.stopAnimating()
            noReviewsLabel.text = "Failed to load reviews."
            noReviewsLabel.isHidden = false
        }
    }

    func showReviewsPaginationLoading(_ isLoading: Bool) {
        if isLoading {
            paginationLoadingIndicator.startAnimating()
        } else {
            paginationLoadingIndicator.stopAnimating()
        }
    }

    func appendReviews(_ reviews: [MovieReview]) {
        reviews.forEach { review in
            let card = ReviewCardView()
            card.configure(with: review)
            reviewsStack.addArrangedSubview(card)
        }
    }

    func endRefreshing() {
        refreshControl.endRefreshing()
    }

    func showLoadingState() {
        scrollView.isHidden = false
        errorStack.isHidden = true
        loadingIndicator.stopAnimating()

        titleLabel.text = "Loading Movie Title Placeholder"
        taglineLabel.text = "Loading tagline placeholder text that covers lines"
        taglineLabel.isHidden = false
        overviewLabel.text = "This is a loading overview placeholder paragraph. " +
                             "It is long enough to cover multiple lines so that the skeleton block " +
                             "resembles a text block."

        ratingBadge.update(value: "0.0")
        runtimeBadge.update(value: "120m")
        yearBadge.update(value: "2026")

        backdropImageView.loadImage(from: nil)
        posterImageView.loadImage(from: nil)

        genreStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        genreStack.addArrangedSubview(GenreTagView(name: "Genre Tag"))

        contentView.showSkeleton(recursive: true)
    }

    func showErrorState(_ error: Error) {
        scrollView.isHidden = true
        loadingIndicator.stopAnimating()
        contentView.hideSkeleton(recursive: true)
        errorLabel.text = error.localizedDescription
        errorStack.isHidden = false
    }

    @objc private func retryTapped() {
        onRetryTapped?()
    }

    @objc private func refreshTriggered() {
        onRefresh?()
    }
}
