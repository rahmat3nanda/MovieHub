import Foundation
import DIContainer
import DomainKit

protocol MovieListInteractorInputProtocol: AnyObject {
    var presenter: MovieListInteractorOutputProtocol? { get set }
    func fetchMovies(page: Int)
}

protocol MovieListInteractorOutputProtocol: AnyObject {
    func didFetchMovies(with result: Result<MovieList, Error>)
}

final class MovieListInteractor: MovieListInteractorInputProtocol {
    weak var presenter: MovieListInteractorOutputProtocol?
    private let section: HomeSectionType
    
    @Inject private var getNowPlayingMoviesUseCase: GetNowPlayingMoviesUseCase
    @Inject private var getPopularMoviesUseCase: GetPopularMoviesUseCase
    @Inject private var getTopRatedMoviesUseCase: GetTopRatedMoviesUseCase
    @Inject private var getUpcomingMoviesUseCase: GetUpcomingMoviesUseCase
    
    init(section: HomeSectionType) {
        self.section = section
    }
    
    func fetchMovies(page: Int) {
        Task {
            do {
                let request = MovieListRequest(page: page, language: "en-US", region: "")
                let response: MovieList
                switch section {
                case .nowPlaying:
                    response = try await getNowPlayingMoviesUseCase.execute(request: request)
                case .popular:
                    response = try await getPopularMoviesUseCase.execute(request: request)
                case .topRated:
                    response = try await getTopRatedMoviesUseCase.execute(request: request)
                case .upcoming:
                    response = try await getUpcomingMoviesUseCase.execute(request: request)
                }
                presenter?.didFetchMovies(with: .success(response))
            } catch {
                presenter?.didFetchMovies(with: .failure(error))
            }
        }
    }
}
