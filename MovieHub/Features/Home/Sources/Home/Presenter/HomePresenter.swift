import Foundation
import DIContainer
import DomainKit
import SharedUI

public enum HomeSectionType {
    case nowPlaying
    case popular
    case topRated
    case upcoming
    
    public var categoryName: String {
        switch self {
        case .nowPlaying: return "Now Playing"
        case .popular: return "Popular"
        case .topRated: return "Top Rated"
        case .upcoming: return "Upcoming"
        }
    }
}

public protocol HomePresenterProtocol: AnyObject {
    var view: HomeViewProtocol? { get set }
    var interactor: HomeInteractorInputProtocol? { get set }
    var router: HomeRouterProtocol? { get set }
    
    func viewDidLoad()
    func retryTapped(for section: HomeSectionType)
    func seeAllTapped(for section: HomeSectionType)
    func movieSelected(_ movie: Movie)
}

public final class HomePresenter: HomePresenterProtocol {
    public weak var view: HomeViewProtocol?
    public var interactor: HomeInteractorInputProtocol?
    public var router: HomeRouterProtocol?
    
    @Inject private var toastService: ToastService
    
    public init(
        view: HomeViewProtocol,
        interactor: HomeInteractorInputProtocol,
        router: HomeRouterProtocol
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    public func viewDidLoad() {
        view?.showNowPlayingState(.loading)
        view?.showPopularState(.loading)
        view?.showTopRatedState(.loading)
        view?.showUpcomingState(.loading)
        
        interactor?.fetchNowPlaying()
        interactor?.fetchPopular()
        interactor?.fetchTopRated()
        interactor?.fetchUpcoming()
    }
    
    public func retryTapped(for section: HomeSectionType) {
        switch section {
        case .nowPlaying:
            view?.showNowPlayingState(.loading)
            interactor?.fetchNowPlaying()
        case .popular:
            view?.showPopularState(.loading)
            interactor?.fetchPopular()
        case .topRated:
            view?.showTopRatedState(.loading)
            interactor?.fetchTopRated()
        case .upcoming:
            view?.showUpcomingState(.loading)
            interactor?.fetchUpcoming()
        }
    }
    
    public func seeAllTapped(for section: HomeSectionType) {
        toastService.show(message: "See All tapped for \(section.categoryName)", type: .info)
        router?.navigateToSeeAll(for: section)
    }
    
    public func movieSelected(_ movie: Movie) {
        toastService.show(message: "Selected Movie: \(movie.title)", type: .success)
        router?.navigateToMovieDetails(for: movie)
    }
}

// MARK: - HomeInteractorOutputProtocol

extension HomePresenter: HomeInteractorOutputProtocol {
    
    public func didFetchNowPlaying(with result: Result<[Movie], Error>) {
        switch result {
        case .success(let movies):
            if movies.isEmpty {
                view?.showNowPlayingState(.empty)
            } else {
                view?.showNowPlayingState(.loaded(movies))
            }
        case .failure(let error):
            view?.showNowPlayingState(.error(error))
        }
    }
    
    public func didFetchPopular(with result: Result<[Movie], Error>) {
        switch result {
        case .success(let movies):
            if movies.isEmpty {
                view?.showPopularState(.empty)
            } else {
                view?.showPopularState(.loaded(movies))
            }
        case .failure(let error):
            view?.showPopularState(.error(error))
        }
    }
    
    public func didFetchTopRated(with result: Result<[Movie], Error>) {
        switch result {
        case .success(let movies):
            if movies.isEmpty {
                view?.showTopRatedState(.empty)
            } else {
                view?.showTopRatedState(.loaded(movies))
            }
        case .failure(let error):
            view?.showTopRatedState(.error(error))
        }
    }
    
    public func didFetchUpcoming(with result: Result<[Movie], Error>) {
        switch result {
        case .success(let movies):
            if movies.isEmpty {
                view?.showUpcomingState(.empty)
            } else {
                view?.showUpcomingState(.loaded(movies))
            }
        case .failure(let error):
            view?.showUpcomingState(.error(error))
        }
    }
}
