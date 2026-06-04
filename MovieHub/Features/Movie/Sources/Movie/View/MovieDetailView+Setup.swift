import UIKit

// MARK: - MovieDetailView Layout Setup

extension MovieDetailView {

    func setupUI() {
        backgroundColor = .background

        addSubview(scrollView)
        addSubview(appBarBackground)
        addSubview(appBar)
        addSubview(errorStack)
        addSubview(loadingIndicator)

        scrollView.refreshControl = refreshControl
        scrollView.delegate = self
        scrollView.addSubview(contentView)

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
        setupHeroAndPosterLayout()
        setupTitleAndStatsLayout()
        setupGenresAndOverviewLayout()
        setupReviewsLayout()
    }

    private func setupHeroAndPosterLayout() {
        contentView.addSubview(backdropImageView)
        backdropImageView.addSubview(backdropOverlay)
        backdropOverlay.layer.addSublayer(backdropGradient)

        backdropTopConstraint = backdropImageView.anchors.top.pin()
        backdropImageView.anchors.leading.pin()
        backdropImageView.anchors.trailing.pin()
        backdropHeightConstraint = backdropImageView.anchors.height.equal(280)

        backdropOverlay.anchors.edges.pin()

        contentView.addSubview(posterImageView)
        posterImageView.anchors.leading.pin(inset: 20)
        posterImageView.anchors.top.spacing(-60, to: backdropImageView.anchors.bottom)
        posterImageView.anchors.width.equal(110)
        posterImageView.anchors.height.equal(165)
    }

    private func setupTitleAndStatsLayout() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(taglineLabel)

        titleLabel.anchors.leading.spacing(14, to: posterImageView.anchors.trailing)
        titleLabel.anchors.trailing.pin(inset: 16)
        titleLabel.anchors.top.spacing(20, to: backdropImageView.anchors.bottom)

        taglineLabel.anchors.leading.spacing(14, to: posterImageView.anchors.trailing)
        taglineLabel.anchors.trailing.pin(inset: 16)
        taglineLabel.anchors.top.spacing(6, to: titleLabel.anchors.bottom)

        statsStack.addArrangedSubview(ratingBadge)
        statsStack.addArrangedSubview(runtimeBadge)
        statsStack.addArrangedSubview(yearBadge)

        contentView.addSubview(statsStack)
        statsStack.anchors.top.spacing(16, to: posterImageView.anchors.bottom)
        statsStack.anchors.leading.pin(inset: 16)
        statsStack.anchors.trailing.pin(inset: 16)
        statsStack.anchors.height.equal(70)
    }

    private func setupGenresAndOverviewLayout() {
        genreScrollView.addSubview(genreStack)
        genreStack.anchors.edges.pin(insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        genreStack.anchors.height.equal(genreScrollView.anchors.height)

        contentView.addSubview(genreScrollView)
        genreScrollView.anchors.top.spacing(16, to: statsStack.anchors.bottom)
        genreScrollView.anchors.leading.pin()
        genreScrollView.anchors.trailing.pin()
        genreScrollView.anchors.height.equal(36)

        contentView.addSubview(overviewSectionLabel)
        contentView.addSubview(overviewLabel)

        overviewSectionLabel.anchors.top.spacing(24, to: genreScrollView.anchors.bottom)
        overviewSectionLabel.anchors.leading.pin(inset: 16)
        overviewSectionLabel.anchors.trailing.pin(inset: 16)

        overviewLabel.anchors.top.spacing(10, to: overviewSectionLabel.anchors.bottom)
        overviewLabel.anchors.leading.pin(inset: 16)
        overviewLabel.anchors.trailing.pin(inset: 16)
    }

    private func setupReviewsLayout() {
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

        contentView.addSubview(paginationLoadingIndicator)
        paginationLoadingIndicator.anchors.top.spacing(16, to: reviewsStack.anchors.bottom)
        paginationLoadingIndicator.anchors.centerX.align()

        let bottomAnchorView = UIView()
        contentView.addSubview(bottomAnchorView)
        bottomAnchorView.anchors.top.spacing(16, to: paginationLoadingIndicator.anchors.bottom)
        bottomAnchorView.anchors.leading.pin()
        bottomAnchorView.anchors.trailing.pin()
        bottomAnchorView.anchors.bottom.pin()
        bottomAnchorView.anchors.height.equal(40)
    }
}

// MARK: - UIScrollViewDelegate

extension MovieDetailView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let threshold: CGFloat = 100.0
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
