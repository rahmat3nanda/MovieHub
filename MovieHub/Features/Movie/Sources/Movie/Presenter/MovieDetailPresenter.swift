import Foundation
import DomainKit
import DIContainer
import SharedUI

protocol MovieDetailPresenterProtocol: AnyObject {
    var view: MovieDetailViewProtocol? { get set }
    var interactor: MovieDetailInteractorInputProtocol? { get set }
    var router: MovieDetailRouterProtocol? { get set }

    func viewDidLoad()
    func pullToRefresh()
    func backTapped()
    func shareTapped()
    func retryTapped()
    func loadMoreReviews()
}

final class MovieDetailPresenter: MovieDetailPresenterProtocol {
    weak var view: MovieDetailViewProtocol?
    var interactor: MovieDetailInteractorInputProtocol?
    var router: MovieDetailRouterProtocol?

    private let movie: Movie

    // MARK: - Reviews pagination state

    private var reviews: [MovieReview] = []
    private var reviewsCurrentPage = 0
    private var reviewsTotalPages = 1
    private var isReviewsFetchInProgress = false
    private var isFirstReviewsLoad = true

    @Inject private var toastService: ToastService

    init(
        view: MovieDetailViewProtocol,
        interactor: MovieDetailInteractorInputProtocol,
        router: MovieDetailRouterProtocol,
        movie: Movie
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.movie = movie
    }

    func viewDidLoad() {
        view?.showDetailState(.loading)
        interactor?.fetchDetail(movieId: movie.id)
        fetchReviewsPage(1)
    }

    func pullToRefresh() {
        interactor?.fetchDetail(movieId: movie.id)
        resetAndFetchReviews()
    }

    func backTapped() {
        router?.navigateBack()
    }

    func shareTapped() {
        toastService.show(message: "Share \(movie.title)", type: .info)
    }

    func retryTapped() {
        view?.showDetailState(.loading)
        interactor?.fetchDetail(movieId: movie.id)
        resetAndFetchReviews()
    }

    func loadMoreReviews() {
        guard !isReviewsFetchInProgress, reviewsCurrentPage < reviewsTotalPages else { return }
        fetchReviewsPage(reviewsCurrentPage + 1)
    }

    // MARK: - Private

    private func resetAndFetchReviews() {
        reviews = []
        reviewsCurrentPage = 0
        reviewsTotalPages = 1
        isFirstReviewsLoad = true
        fetchReviewsPage(1)
    }

    private func fetchReviewsPage(_ page: Int) {
        guard !isReviewsFetchInProgress else { return }
        isReviewsFetchInProgress = true

        if isFirstReviewsLoad {
            view?.showReviewsState(.loading)
        } else {
            view?.showReviewsPaginationLoading(true)
        }

        interactor?.fetchReviews(movieId: movie.id, page: page)
    }
}

// MARK: - MovieDetailInteractorOutputProtocol

extension MovieDetailPresenter: MovieDetailInteractorOutputProtocol {

    func didFetchDetail(with result: Result<Movie, Error>) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.view?.endRefreshing()
            switch result {
            case .success(let movie):
                self.view?.showDetailState(.loaded(movie))
            case .failure(let error):
                self.view?.showDetailState(.error(error))
            }
        }
    }

    func didFetchReviews(with result: Result<MovieReviewList, Error>) {
        isReviewsFetchInProgress = false
        let wasFirstLoad = isFirstReviewsLoad
        isFirstReviewsLoad = false

        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.view?.showReviewsPaginationLoading(false)

            switch result {
            case .success(let reviewList):
                self.reviewsCurrentPage = reviewList.page
                self.reviewsTotalPages = reviewList.totalPages

                if reviewList.page == 1 {
                    self.reviews = reviewList.results
                    if self.reviews.isEmpty {
                        self.view?.showReviewsState(.empty)
                    } else {
                        self.view?.showReviewsState(.loaded(self.reviews))
                    }
                } else {
                    self.reviews.append(contentsOf: reviewList.results)
                    self.view?.appendReviews(reviewList.results)
                }

            case .failure(let error):
                if wasFirstLoad {
                    self.view?.showReviewsState(.error(error))
                } else {
                    self.toastService.show(message: error.localizedDescription, type: .error)
                }
            }
        }
    }
}
