import UIKit
import DomainKit

public protocol HomeViewProtocol: AnyObject {
    func showNowPlayingState(_ state: SectionState)
    func showPopularState(_ state: SectionState)
    func showTopRatedState(_ state: SectionState)
    func showUpcomingState(_ state: SectionState)
    func endRefreshing()
}

public final class HomeViewController: UIViewController {
    
    // MARK: - Presenter Reference
    public var presenter: HomePresenterProtocol?
    
    // MARK: - View Accessor
    private var homeView: HomeView {
        guard let customView = view as? HomeView else {
            fatalError("Expected view of type HomeView")
        }
        return customView
    }
    
    // MARK: - Lifecycle
    
    public override func loadView() {
        view = HomeView()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupListeners()
        presenter?.viewDidLoad()
    }
    
    // MARK: - Setup Listeners
    
    private func setupListeners() {
        // Now Playing Section Listeners
        homeView.nowPlayingSection.onRetry = { [weak self] in
            self?.presenter?.retryTapped(for: .nowPlaying)
        }
        homeView.nowPlayingSection.onSeeAll = { [weak self] in
            self?.presenter?.seeAllTapped(for: .nowPlaying)
        }
        homeView.nowPlayingSection.onSelectMovie = { [weak self] movie in
            self?.presenter?.movieSelected(movie)
        }
        
        // Popular Section Listeners
        homeView.popularSection.onRetry = { [weak self] in
            self?.presenter?.retryTapped(for: .popular)
        }
        homeView.popularSection.onSeeAll = { [weak self] in
            self?.presenter?.seeAllTapped(for: .popular)
        }
        homeView.popularSection.onSelectMovie = { [weak self] movie in
            self?.presenter?.movieSelected(movie)
        }
        
        // Top Rated Section Listeners
        homeView.topRatedSection.onRetry = { [weak self] in
            self?.presenter?.retryTapped(for: .topRated)
        }
        homeView.topRatedSection.onSeeAll = { [weak self] in
            self?.presenter?.seeAllTapped(for: .topRated)
        }
        homeView.topRatedSection.onSelectMovie = { [weak self] movie in
            self?.presenter?.movieSelected(movie)
        }
        
        // Upcoming Section Listeners
        homeView.upcomingSection.onRetry = { [weak self] in
            self?.presenter?.retryTapped(for: .upcoming)
        }
        homeView.upcomingSection.onSeeAll = { [weak self] in
            self?.presenter?.seeAllTapped(for: .upcoming)
        }
        homeView.upcomingSection.onSelectMovie = { [weak self] movie in
            self?.presenter?.movieSelected(movie)
        }
        
        // Pull to Refresh Listener
        homeView.onRefresh = { [weak self] in
            self?.presenter?.pullToRefresh()
        }
        
        // Search Action Listener
        homeView.appBar.onSearchTapped = { [weak self] in
            self?.presenter?.searchTapped()
        }
    }
}

// MARK: - HomeViewProtocol

extension HomeViewController: HomeViewProtocol {
    
    public func showNowPlayingState(_ state: SectionState) {
        DispatchQueue.main.async { [weak self] in
            self?.homeView.nowPlayingSection.state = state
        }
    }
    
    public func showPopularState(_ state: SectionState) {
        DispatchQueue.main.async { [weak self] in
            self?.homeView.popularSection.state = state
        }
    }
    
    public func showTopRatedState(_ state: SectionState) {
        DispatchQueue.main.async { [weak self] in
            self?.homeView.topRatedSection.state = state
        }
    }
    
    public func showUpcomingState(_ state: SectionState) {
        DispatchQueue.main.async { [weak self] in
            self?.homeView.upcomingSection.state = state
        }
    }
    
    public func endRefreshing() {
        DispatchQueue.main.async { [weak self] in
            self?.homeView.refreshControl.endRefreshing()
        }
    }
}
