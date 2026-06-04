import UIKit
import DomainKit
import DesignSystem
import SharedUI
import UtilityKit

// MARK: - MovieDetailAppBarView

final class MovieDetailAppBarView: UIView {

    var onBackTapped: (() -> Void)?
    var onShareTapped: (() -> Void)?

    private lazy var backButton: UIButton = {
        let btn = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
        btn.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        btn.layer.cornerRadius = 20
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        return btn
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "MovieHub"
        label.textColor = .secondary
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        return label
    }()

    private lazy var shareButton: UIButton = {
        let btn = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        btn.setImage(UIImage(systemName: "square.and.arrow.up", withConfiguration: config), for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        btn.layer.cornerRadius = 20
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
        return btn
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
        addSubview(shareButton)

        backButton.anchors.leading.pin(inset: 16)
        backButton.anchors.centerY.align()
        backButton.anchors.size.equal(CGSize(width: 40, height: 40))

        titleLabel.anchors.center.align(with: self)

        shareButton.anchors.trailing.pin(inset: 16)
        shareButton.anchors.centerY.align()
        shareButton.anchors.size.equal(CGSize(width: 40, height: 40))
    }

    @objc private func backTapped() { onBackTapped?() }
    @objc private func shareTapped() { onShareTapped?() }
}

// MARK: - GenreTagView

private final class GenreTagView: UIView {

    private let label: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 12, weight: .semibold)
        l.textColor = .secondary
        l.textAlignment = .center
        return l
    }()

    init(name: String) {
        super.init(frame: .zero)
        backgroundColor = UIColor.secondary.withAlphaComponent(0.15)
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.secondary.withAlphaComponent(0.4).cgColor
        addSubview(label)
        label.text = name
        label.anchors.edges.pin(insets: UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - StatBadgeView

private final class StatBadgeView: UIView {

    private let iconView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = UIColor(red: 245/255, green: 158/255, blue: 11/255, alpha: 1)
        return iv
    }()

    private let valueLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14, weight: .bold)
        l.textColor = .white
        return l
    }()

    private let subtitleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 11, weight: .medium)
        l.textColor = .systemGray
        return l
    }()

    private let stack: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.spacing = 2
        s.alignment = .center
        return s
    }()

    // swiftlint:disable:next function_default_parameter_at_end
    init(icon: String, value: String, subtitle: String, iconTintColor: UIColor? = nil) {
        super.init(frame: .zero)
        let resolvedTint = iconTintColor ?? UIColor(red: 245/255, green: 158/255, blue: 11/255, alpha: 1)
        iconView.image = UIImage(systemName: icon)
        iconView.tintColor = resolvedTint
        valueLabel.text = value
        subtitleLabel.text = subtitle

        backgroundColor = UIColor.white.withAlphaComponent(0.06)
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.border.cgColor

        let iconRow = UIStackView(arrangedSubviews: [iconView, valueLabel])
        iconRow.axis = .horizontal
        iconRow.spacing = 4
        iconRow.alignment = .center
        iconView.anchors.size.equal(CGSize(width: 16, height: 16))

        stack.addArrangedSubview(iconRow)
        stack.addArrangedSubview(subtitleLabel)

        addSubview(stack)
        stack.anchors.edges.pin(insets: UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(value: String) {
        valueLabel.text = value
    }
}

// MARK: - ReviewCardView

final class ReviewCardView: UIView {

    private let avatarView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 22
        iv.backgroundColor = UIColor.secondary.withAlphaComponent(0.3)
        iv.image = UIImage(systemName: "person.fill")
        iv.tintColor = .secondary
        return iv
    }()

    private let authorLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14, weight: .bold)
        l.textColor = .white
        return l
    }()

    private let usernameLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 12, weight: .regular)
        l.textColor = .systemGray
        return l
    }()

    private let ratingStack: UIStackView = {
        let s = UIStackView()
        s.axis = .horizontal
        s.spacing = 3
        s.alignment = .center
        return s
    }()

    private let starIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "star.fill"))
        iv.tintColor = UIColor(red: 245/255, green: 158/255, blue: 11/255, alpha: 1)
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let ratingLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 12, weight: .semibold)
        l.textColor = UIColor(red: 245/255, green: 158/255, blue: 11/255, alpha: 1)
        return l
    }()

    private let contentLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 13, weight: .regular)
        l.textColor = UIColor.white.withAlphaComponent(0.8)
        l.numberOfLines = 5
        l.lineBreakMode = .byTruncatingTail
        return l
    }()

    private let dateLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 11, weight: .regular)
        l.textColor = .systemGray
        return l
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = UIColor.white.withAlphaComponent(0.05)
        layer.cornerRadius = 16
        layer.borderWidth = 1
        layer.borderColor = UIColor.border.cgColor

        ratingStack.addArrangedSubview(starIcon)
        ratingStack.addArrangedSubview(ratingLabel)
        starIcon.anchors.size.equal(CGSize(width: 12, height: 12))

        let headerRight = UIStackView(arrangedSubviews: [authorLabel, usernameLabel, ratingStack])
        headerRight.axis = .vertical
        headerRight.spacing = 2
        headerRight.alignment = .leading

        let headerStack = UIStackView(arrangedSubviews: [avatarView, headerRight])
        headerStack.axis = .horizontal
        headerStack.spacing = 10
        headerStack.alignment = .center
        avatarView.anchors.size.equal(CGSize(width: 44, height: 44))

        let mainStack = UIStackView(arrangedSubviews: [headerStack, contentLabel, dateLabel])
        mainStack.axis = .vertical
        mainStack.spacing = 10

        addSubview(mainStack)
        mainStack.anchors.edges.pin(insets: UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14))
    }

    func configure(with review: MovieReview) {
        authorLabel.text = review.author.isEmpty ? review.authorDetails.username : review.author
        usernameLabel.text = "@\(review.authorDetails.username)"

        if let rating = review.authorDetails.rating {
            ratingStack.isHidden = false
            ratingLabel.text = String(format: "%.1f", rating)
        } else {
            ratingStack.isHidden = true
        }

        contentLabel.text = review.content

        // Parse date
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = formatter.date(from: review.createdAt) {
            let display = DateFormatter()
            display.dateStyle = .medium
            dateLabel.text = display.string(from: date)
        } else {
            dateLabel.text = review.createdAt
        }

        // Avatar
        if let avatarPath = review.authorDetails.avatarPath {
            let cleaned = avatarPath.hasPrefix("/https://") ? String(avatarPath.dropFirst()) :
                          avatarPath.hasPrefix("/http://") ? String(avatarPath.dropFirst()) :
                          "https://image.tmdb.org/t/p/w200\(avatarPath)"
            if let url = URL(string: cleaned) {
                avatarView.kf_setImage(with: url)
            }
        }
    }
}

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

    private let appBarBackground: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.background.withAlphaComponent(0.85)
        return v
    }()

    private var backdropTopConstraint: NSLayoutConstraint?
    private var backdropHeightConstraint: NSLayoutConstraint?

    // MARK: - Scroll & Content

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.alwaysBounceVertical = true
        sv.contentInsetAdjustmentBehavior = .never
        return sv
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.tintColor = .secondary
        rc.addTarget(self, action: #selector(refreshTriggered), for: .valueChanged)
        return rc
    }()

    private let contentView = UIView()

    // MARK: - Hero Backdrop

    private let backdropImageView: RemoteImageView = {
        let iv = RemoteImageView()
        iv.layer.cornerRadius = 0
        iv.clipsToBounds = true
        return iv
    }()

    private let backdropGradient: CAGradientLayer = {
        let g = CAGradientLayer()
        g.colors = [
            UIColor.clear.cgColor,
            UIColor(red: 17/255, green: 20/255, blue: 21/255, alpha: 1).cgColor
        ]
        g.locations = [0.3, 1.0]
        return g
    }()

    private let backdropOverlay: UIView = {
        let v = UIView()
        return v
    }()

    // MARK: - Poster

    private let posterImageView: RemoteImageView = {
        let iv = RemoteImageView()
        iv.layer.cornerRadius = 16
        iv.clipsToBounds = true
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.border.cgColor
        iv.backgroundColor = .background
        return iv
    }()

    // MARK: - Title Area

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 26, weight: .bold)
        l.textColor = .white
        l.numberOfLines = 0
        return l
    }()

    private let taglineLabel: UILabel = {
        let l = UILabel()
        l.font = .italicSystemFont(ofSize: 14)
        l.textColor = UIColor.systemGray
        l.numberOfLines = 2
        return l
    }()

    // MARK: - Stats Row

    private let ratingBadge = StatBadgeView(icon: "star.fill", value: "0.0", subtitle: "Rating")
    private let runtimeBadge = StatBadgeView(
        icon: "clock.fill",
        value: "--",
        subtitle: "Runtime",
        iconTintColor: .secondary
    )
    private let yearBadge = StatBadgeView(
        icon: "calendar",
        value: "----",
        subtitle: "Year",
        iconTintColor: UIColor(red: 52/255, green: 211/255, blue: 153/255, alpha: 1)
    )

    private let statsStack: UIStackView = {
        let s = UIStackView()
        s.axis = .horizontal
        s.spacing = 10
        s.distribution = .fillEqually
        return s
    }()

    // MARK: - Genres

    private let genreScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsHorizontalScrollIndicator = false
        sv.alwaysBounceHorizontal = true
        return sv
    }()

    private let genreStack: UIStackView = {
        let s = UIStackView()
        s.axis = .horizontal
        s.spacing = 8
        s.alignment = .center
        return s
    }()

    // MARK: - Overview

    private let overviewSectionLabel: UILabel = {
        let l = UILabel()
        l.text = "Overview"
        l.font = .systemFont(ofSize: 20, weight: .bold)
        l.textColor = .white
        return l
    }()

    private let overviewLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14, weight: .regular)
        l.textColor = UIColor.white.withAlphaComponent(0.75)
        l.numberOfLines = 0
        l.lineBreakMode = .byWordWrapping
        return l
    }()

    // MARK: - Reviews

    private let reviewsSectionLabel: UILabel = {
        let l = UILabel()
        l.text = "Reviews"
        l.font = .systemFont(ofSize: 20, weight: .bold)
        l.textColor = .white
        return l
    }()

    private let reviewsLoadingIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .medium)
        ai.color = .secondary
        ai.hidesWhenStopped = true
        return ai
    }()

    private let reviewsStack: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.spacing = 12
        return s
    }()

    private let noReviewsLabel: UILabel = {
        let l = UILabel()
        l.text = "No reviews yet."
        l.font = .systemFont(ofSize: 14, weight: .medium)
        l.textColor = .systemGray
        l.textAlignment = .center
        l.isHidden = true
        return l
    }()

    private let paginationLoadingIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .medium)
        ai.color = .secondary
        ai.hidesWhenStopped = true
        return ai
    }()

    // MARK: - Error & Loading States

    private let errorLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14, weight: .medium)
        l.textColor = .systemRed
        l.numberOfLines = 3
        l.textAlignment = .center
        return l
    }()

    private lazy var retryButton: UIButton = {
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

    private let errorStack: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.spacing = 12
        s.alignment = .center
        s.isHidden = true
        return s
    }()

    private let loadingIndicator: UIActivityIndicatorView = {
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

    // MARK: - Setup UI

    private func setupUI() {
        backgroundColor = .background

        // App bar
        addSubview(scrollView)
        addSubview(appBarBackground)
        addSubview(appBar)
        addSubview(errorStack)
        addSubview(loadingIndicator)

        scrollView.refreshControl = refreshControl
        scrollView.delegate = self
        scrollView.addSubview(contentView)

        // Error stack
        errorStack.addArrangedSubview(errorLabel)
        errorStack.addArrangedSubview(retryButton)

        appBar.anchors.top.pin(to: safeAreaLayoutGuide)
        appBar.anchors.leading.pin()
        appBar.anchors.trailing.pin()
        appBar.anchors.height.equal(56)

        appBarBackground.anchors.top.pin()
        appBarBackground.anchors.leading.pin()
        appBarBackground.anchors.trailing.pin()
        appBarBackground.anchors.bottom.equal(appBar.anchors.bottom)

        scrollView.anchors.top.pin()
        scrollView.anchors.leading.pin()
        scrollView.anchors.trailing.pin()
        scrollView.anchors.bottom.pin()

        contentView.anchors.edges.pin()
        contentView.anchors.width.equal(scrollView.anchors.width)

        loadingIndicator.anchors.center.align(with: self)

        errorStack.anchors.center.align(with: self)
        errorStack.anchors.leading.pin(inset: 32)
        errorStack.anchors.trailing.pin(inset: 32)

        appBar.onBackTapped = { [weak self] in self?.onBackTapped?() }
        appBar.onShareTapped = { [weak self] in self?.onShareTapped?() }

        setupContentLayout()
    }

    private func setupContentLayout() {
        // Backdrop
        contentView.addSubview(backdropImageView)
        backdropImageView.addSubview(backdropOverlay)
        backdropOverlay.layer.addSublayer(backdropGradient)

        backdropTopConstraint = backdropImageView.anchors.top.pin()
        backdropImageView.anchors.leading.pin()
        backdropImageView.anchors.trailing.pin()
        backdropHeightConstraint = backdropImageView.anchors.height.equal(280)

        backdropOverlay.anchors.edges.pin()

        // Poster overlapping backdrop
        contentView.addSubview(posterImageView)
        posterImageView.anchors.leading.pin(inset: 20)
        posterImageView.anchors.top.spacing(-60, to: backdropImageView.anchors.bottom)
        posterImageView.anchors.width.equal(110)
        posterImageView.anchors.height.equal(165)

        // Title block next to poster
        contentView.addSubview(titleLabel)
        contentView.addSubview(taglineLabel)

        titleLabel.anchors.leading.spacing(14, to: posterImageView.anchors.trailing)
        titleLabel.anchors.trailing.pin(inset: 16)
        titleLabel.anchors.top.spacing(20, to: backdropImageView.anchors.bottom)

        taglineLabel.anchors.leading.spacing(14, to: posterImageView.anchors.trailing)
        taglineLabel.anchors.trailing.pin(inset: 16)
        taglineLabel.anchors.top.spacing(6, to: titleLabel.anchors.bottom)

        // Stats below poster (after it ends)
        statsStack.addArrangedSubview(ratingBadge)
        statsStack.addArrangedSubview(runtimeBadge)
        statsStack.addArrangedSubview(yearBadge)

        contentView.addSubview(statsStack)
        statsStack.anchors.top.spacing(16, to: posterImageView.anchors.bottom)
        statsStack.anchors.leading.pin(inset: 16)
        statsStack.anchors.trailing.pin(inset: 16)
        statsStack.anchors.height.equal(70)

        // Genres
        genreScrollView.addSubview(genreStack)
        genreStack.anchors.edges.pin(insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        genreStack.anchors.height.equal(genreScrollView.anchors.height)

        contentView.addSubview(genreScrollView)
        genreScrollView.anchors.top.spacing(16, to: statsStack.anchors.bottom)
        genreScrollView.anchors.leading.pin()
        genreScrollView.anchors.trailing.pin()
        genreScrollView.anchors.height.equal(36)

        // Overview section
        contentView.addSubview(overviewSectionLabel)
        contentView.addSubview(overviewLabel)

        overviewSectionLabel.anchors.top.spacing(24, to: genreScrollView.anchors.bottom)
        overviewSectionLabel.anchors.leading.pin(inset: 16)
        overviewSectionLabel.anchors.trailing.pin(inset: 16)

        overviewLabel.anchors.top.spacing(10, to: overviewSectionLabel.anchors.bottom)
        overviewLabel.anchors.leading.pin(inset: 16)
        overviewLabel.anchors.trailing.pin(inset: 16)

        // Reviews section
        contentView.addSubview(reviewsSectionLabel)
        contentView.addSubview(reviewsLoadingIndicator)
        contentView.addSubview(reviewsStack)
        contentView.addSubview(noReviewsLabel)

        reviewsSectionLabel.anchors.top.spacing(28, to: overviewLabel.anchors.bottom)
        reviewsSectionLabel.anchors.leading.pin(inset: 16)

        reviewsLoadingIndicator.anchors.centerY.equal(reviewsSectionLabel.anchors.centerY)
        reviewsLoadingIndicator.anchors.trailing.pin(inset: 16)

        reviewsStack.anchors.top.spacing(14, to: reviewsSectionLabel.anchors.bottom)
        reviewsStack.anchors.leading.pin(inset: 16)
        reviewsStack.anchors.trailing.pin(inset: 16)

        noReviewsLabel.anchors.top.spacing(14, to: reviewsSectionLabel.anchors.bottom)
        noReviewsLabel.anchors.leading.pin(inset: 16)
        noReviewsLabel.anchors.trailing.pin(inset: 16)

        // Pagination loading indicator
        contentView.addSubview(paginationLoadingIndicator)
        paginationLoadingIndicator.anchors.top.spacing(16, to: reviewsStack.anchors.bottom)
        paginationLoadingIndicator.anchors.centerX.align()

        // Bottom anchor for contentView
        let bottomAnchorView = UIView()
        contentView.addSubview(bottomAnchorView)
        bottomAnchorView.anchors.top.spacing(16, to: paginationLoadingIndicator.anchors.bottom)
        bottomAnchorView.anchors.leading.pin()
        bottomAnchorView.anchors.trailing.pin()
        bottomAnchorView.anchors.bottom.pin()
        bottomAnchorView.anchors.height.equal(40)
    }

    // MARK: - Configuration

    func configure(with movie: Movie) {
        // Hide loading/error
        loadingIndicator.stopAnimating()
        errorStack.isHidden = true
        scrollView.isHidden = false

        contentView.hideSkeleton(recursive: true)

        // Backdrop
        if let backdrop = movie.backdropPath {
            backdropImageView.loadImage(from: "https://image.tmdb.org/t/p/w780\(backdrop)", placeholder: nil)
        } else if let poster = movie.posterPath {
            backdropImageView.loadImage(from: "https://image.tmdb.org/t/p/w780\(poster)", placeholder: nil)
        }

        // Poster
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
            let h = runtime / 60
            let m = runtime % 60
            runtimeBadge.update(value: h > 0 ? "\(h)h \(m)m" : "\(m)m")
        } else {
            runtimeBadge.update(value: "N/A")
        }

        if let year = movie.releaseDate.split(separator: "-").first {
            yearBadge.update(value: String(year))
        } else {
            yearBadge.update(value: movie.releaseDate)
        }

        overviewLabel.text = movie.overview.isEmpty ? "No overview available." : movie.overview

        // Genres
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

            // Add 3 dummy review skeleton cards
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

        // 1. Set placeholder texts to size the skeletons correctly
        titleLabel.text = "Loading Movie Title Placeholder"
        taglineLabel.text = "Loading tagline placeholder text that covers lines"
        taglineLabel.isHidden = false
        overviewLabel.text = "This is a loading overview placeholder paragraph. " +
                             "It is long enough to cover multiple lines so that the skeleton block " +
                             "resembles a text block."

        // 2. Set placeholders for badges
        ratingBadge.update(value: "0.0")
        runtimeBadge.update(value: "120m")
        yearBadge.update(value: "2026")

        // 3. Clear backdrop/poster to trigger skeletons
        backdropImageView.loadImage(from: nil)
        posterImageView.loadImage(from: nil)

        // 4. Hide/clear genre stack during loading
        genreStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let loadingTag = GenreTagView(name: "Genre Tag")
        genreStack.addArrangedSubview(loadingTag)

        // 5. Trigger skeleton layers recursively on contentView
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

// MARK: - UIScrollViewDelegate

extension MovieDetailView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let threshold: CGFloat = 100.0 // trigger load more when within 100pt of the bottom
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.bounds.size.height
        let scrollOffset = scrollView.contentOffset.y

        if contentHeight > 0 && scrollViewHeight > 0 {
            if scrollOffset + scrollViewHeight >= contentHeight - threshold {
                onLoadMoreReviews?()
            }
        }
    }
}

// MARK: - Kingfisher helper for UIImageView (no SharedUI dependency loop)
import Kingfisher

private extension UIImageView {
    func kf_setImage(with url: URL) {
        kf.setImage(with: url, options: [.transition(.fade(0.25)), .cacheOriginalImage])
    }
}
