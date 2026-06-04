import UIKit
import DomainKit

public protocol MovieDetailViewProtocol: AnyObject {
    func showDetailState(_ state: MovieDetailUIState)
    func showReviewsState(_ state: MovieReviewsUIState)
    func showReviewsPaginationLoading(_ isLoading: Bool)
    func appendReviews(_ reviews: [MovieReview])
    func endRefreshing()
}

public enum MovieDetailUIState {
    case loading
    case loaded(Movie)
    case error(Error)
}

public enum MovieReviewsUIState {
    case loading
    case loaded([MovieReview])
    case empty
    case error(Error)
}

public final class MovieDetailViewController: UIViewController {

    var presenter: MovieDetailPresenterProtocol?

    private var movieDetailView: MovieDetailView {
        guard let v = view as? MovieDetailView else {
            fatalError("Expected view of type MovieDetailView")
        }
        return v
    }

    public override func loadView() {
        view = MovieDetailView()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupListeners()
        presenter?.viewDidLoad()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if navigationController?.interactivePopGestureRecognizer?.delegate === self {
            navigationController?.interactivePopGestureRecognizer?.delegate = nil
        }
    }

    private func setupListeners() {
        movieDetailView.onBackTapped = { [weak self] in
            self?.presenter?.backTapped()
        }
        movieDetailView.onShareTapped = { [weak self] in
            self?.presenter?.shareTapped()
        }
        movieDetailView.onRetryTapped = { [weak self] in
            self?.presenter?.retryTapped()
        }
        movieDetailView.onRefresh = { [weak self] in
            self?.presenter?.pullToRefresh()
        }
        movieDetailView.onLoadMoreReviews = { [weak self] in
            self?.presenter?.loadMoreReviews()
        }
    }
}

// MARK: - UIGestureRecognizerDelegate

extension MovieDetailViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return (navigationController?.viewControllers.count ?? 0) > 1
    }
}

// MARK: - MovieDetailViewProtocol

extension MovieDetailViewController: MovieDetailViewProtocol {

    public func showDetailState(_ state: MovieDetailUIState) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            switch state {
            case .loading:
                self.movieDetailView.showLoadingState()
            case .loaded(let movie):
                self.movieDetailView.configure(with: movie)
            case .error(let error):
                self.movieDetailView.showErrorState(error)
            }
        }
    }

    public func showReviewsState(_ state: MovieReviewsUIState) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.movieDetailView.configureReviews(with: state)
        }
    }

    public func showReviewsPaginationLoading(_ isLoading: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.movieDetailView.showReviewsPaginationLoading(isLoading)
        }
    }

    public func appendReviews(_ reviews: [MovieReview]) {
        DispatchQueue.main.async { [weak self] in
            self?.movieDetailView.appendReviews(reviews)
        }
    }

    public func endRefreshing() {
        DispatchQueue.main.async { [weak self] in
            self?.movieDetailView.endRefreshing()
        }
    }
}
