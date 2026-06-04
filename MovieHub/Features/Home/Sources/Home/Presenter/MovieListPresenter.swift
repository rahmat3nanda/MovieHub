import Foundation
import DomainKit
import DIContainer
import SharedUI

protocol MovieListPresenterProtocol: AnyObject {
    var view: MovieListViewProtocol? { get set }
    var interactor: MovieListInteractorInputProtocol? { get set }
    var router: MovieListRouterProtocol? { get set }
    
    var title: String { get }
    var movies: [Movie] { get }
    var isLoadingFirstPage: Bool { get }
    
    func viewDidLoad()
    func pullToRefresh()
    func retryTapped()
    func backTapped()
    func movieSelected(_ movie: Movie)
    func loadMoreMovies()
    func searchTapped()
}

final class MovieListPresenter: MovieListPresenterProtocol {
    weak var view: MovieListViewProtocol?
    var interactor: MovieListInteractorInputProtocol?
    var router: MovieListRouterProtocol?
    
    private let section: HomeSectionType
    
    var title: String {
        return section.categoryName
    }
    
    private(set) var movies: [Movie] = []
    private(set) var isLoadingFirstPage: Bool = false
    
    private var currentPage: Int = 1
    private var totalPages: Int = 1
    private var isFetchInProgress: Bool = false
    
    @Inject private var toastService: ToastService
    
    init(
        view: MovieListViewProtocol,
        interactor: MovieListInteractorInputProtocol,
        router: MovieListRouterProtocol,
        section: HomeSectionType
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.section = section
    }
    
    func viewDidLoad() {
        fetchPage(1)
    }
    
    func pullToRefresh() {
        fetchPage(1)
    }
    
    func retryTapped() {
        fetchPage(currentPage)
    }
    
    func backTapped() {
        router?.navigateBack()
    }
    
    func movieSelected(_ movie: Movie) {
        toastService.show(message: "Selected Movie: \(movie.title)", type: .success)
        router?.navigateToMovieDetails(for: movie)
    }
    
    func loadMoreMovies() {
        guard !isFetchInProgress, currentPage < totalPages else { return }
        fetchPage(currentPage + 1)
    }
    
    func searchTapped() {
        toastService.show(message: "Search under development", type: .info)
    }
    
    private func fetchPage(_ page: Int) {
        guard !isFetchInProgress else { return }
        isFetchInProgress = true
        
        if page == 1 {
            isLoadingFirstPage = true
            view?.showState(.loading)
        } else {
            view?.showPaginationLoading(true)
        }
        
        interactor?.fetchMovies(page: page)
    }
}

extension MovieListPresenter: MovieListInteractorOutputProtocol {
    func didFetchMovies(with result: Result<MovieList, Error>) {
        isFetchInProgress = false
        isLoadingFirstPage = false
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.view?.showPaginationLoading(false)
            
            switch result {
            case .success(let movieList):
                self.currentPage = movieList.page
                self.totalPages = movieList.totalPages
                
                if movieList.page == 1 {
                    self.movies = movieList.results
                    if self.movies.isEmpty {
                        self.view?.showState(.empty)
                    } else {
                        self.view?.showState(.loaded(self.movies))
                    }
                } else {
                    self.movies.append(contentsOf: movieList.results)
                    self.view?.updateMovies(self.movies)
                }
                
            case .failure(let error):
                if self.currentPage == 1 && self.movies.isEmpty {
                    self.view?.showState(.error(error))
                } else {
                    self.toastService.show(message: error.localizedDescription, type: .error)
                }
            }
        }
    }
}
