import Foundation
import DIContainer
import DomainKit

public protocol HomeInteractorInputProtocol: AnyObject {
    var presenter: HomeInteractorOutputProtocol? { get set }
    
    func fetchNowPlaying()
    func fetchPopular()
    func fetchTopRated()
    func fetchUpcoming()
}

public protocol HomeInteractorOutputProtocol: AnyObject {
    func didFetchNowPlaying(with result: Result<[Movie], Error>)
    func didFetchPopular(with result: Result<[Movie], Error>)
    func didFetchTopRated(with result: Result<[Movie], Error>)
    func didFetchUpcoming(with result: Result<[Movie], Error>)
}

public final class HomeInteractor: HomeInteractorInputProtocol {
    public weak var presenter: HomeInteractorOutputProtocol?
    
    @Inject private var getNowPlayingMoviesUseCase: GetNowPlayingMoviesUseCase
    @Inject private var getPopularMoviesUseCase: GetPopularMoviesUseCase
    @Inject private var getTopRatedMoviesUseCase: GetTopRatedMoviesUseCase
    @Inject private var getUpcomingMoviesUseCase: GetUpcomingMoviesUseCase
    
    public init() {}
    
    public func fetchNowPlaying() {
        Task {
            do {
                let request = MovieListRequest(page: 1, language: "en-US", region: "")
                let response = try await getNowPlayingMoviesUseCase.execute(request: request)
                presenter?.didFetchNowPlaying(with: .success(response.results))
            } catch {
                presenter?.didFetchNowPlaying(with: .failure(error))
            }
        }
    }
    
    public func fetchPopular() {
        Task {
            do {
                let request = MovieListRequest(page: 1, language: "en-US", region: "")
                let response = try await getPopularMoviesUseCase.execute(request: request)
                presenter?.didFetchPopular(with: .success(response.results))
            } catch {
                presenter?.didFetchPopular(with: .failure(error))
            }
        }
    }
    
    public func fetchTopRated() {
        Task {
            do {
                let request = MovieListRequest(page: 1, language: "en-US", region: "")
                let response = try await getTopRatedMoviesUseCase.execute(request: request)
                presenter?.didFetchTopRated(with: .success(response.results))
            } catch {
                presenter?.didFetchTopRated(with: .failure(error))
            }
        }
    }
    
    public func fetchUpcoming() {
        Task {
            do {
                let request = MovieListRequest(page: 1, language: "en-US", region: "")
                let response = try await getUpcomingMoviesUseCase.execute(request: request)
                presenter?.didFetchUpcoming(with: .success(response.results))
            } catch {
                presenter?.didFetchUpcoming(with: .failure(error))
            }
        }
    }
}
