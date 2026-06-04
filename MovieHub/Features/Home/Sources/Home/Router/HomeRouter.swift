import UIKit
import DomainKit

public protocol HomeRouterProtocol: AnyObject {
    static func createModule() -> HomeViewController
    func navigateToSeeAll(for section: HomeSectionType)
    func navigateToMovieDetails(for movie: Movie)
    func navigateToSearch()
}

public final class HomeRouter: HomeRouterProtocol {
    private weak var viewController: UIViewController?
    
    public init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    public static func createModule() -> HomeViewController {
        let viewController = HomeViewController()
        let router = HomeRouter(viewController: viewController)
        let interactor = HomeInteractor()
        let presenter = HomePresenter(view: viewController, interactor: interactor, router: router)
        
        viewController.presenter = presenter
        interactor.presenter = presenter
        
        return viewController
    }
    
    public func navigateToSeeAll(for section: HomeSectionType) {
        let movieListView = MovieListRouter.createModule(for: section)
        movieListView.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(movieListView, animated: true)
    }
    
    public func navigateToMovieDetails(for movie: Movie) {
        // Navigation placeholder logic - currently handled via toast in presenter
    }
    
    public func navigateToSearch() {
        // Navigation placeholder logic - currently handled via toast in presenter
    }
}
