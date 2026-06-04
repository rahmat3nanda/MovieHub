import Foundation
import DomainKit
import DIContainer

protocol MovieDetailInteractorInputProtocol: AnyObject {
    var presenter: MovieDetailInteractorOutputProtocol? { get set }
    func fetchDetail(movieId: Int)
    func fetchReviews(movieId: Int, page: Int)
}

protocol MovieDetailInteractorOutputProtocol: AnyObject {
    func didFetchDetail(with result: Result<Movie, Error>)
    func didFetchReviews(with result: Result<MovieReviewList, Error>)
}

final class MovieDetailInteractor: MovieDetailInteractorInputProtocol {
    weak var presenter: MovieDetailInteractorOutputProtocol?

    @Inject private var getMovieDetailUseCase: GetMovieDetailUseCase
    @Inject private var getMovieReviewsUseCase: GetMovieReviewsUseCase

    func fetchDetail(movieId: Int) {
        Task {
            do {
                let movie = try await getMovieDetailUseCase.execute(request: MovieRequest(id: movieId))
                presenter?.didFetchDetail(with: .success(movie))
            } catch {
                presenter?.didFetchDetail(with: .failure(error))
            }
        }
    }

    func fetchReviews(movieId: Int, page: Int) {
        Task {
            do {
                let reviews = try await getMovieReviewsUseCase.execute(
                    request: MovieRequest(id: movieId, page: page)
                )
                presenter?.didFetchReviews(with: .success(reviews))
            } catch {
                presenter?.didFetchReviews(with: .failure(error))
            }
        }
    }
}
