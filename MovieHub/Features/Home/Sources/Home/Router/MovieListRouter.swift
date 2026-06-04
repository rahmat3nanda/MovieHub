//
//  MovieListRouter.swift
//  Home
//

import UIKit
import DomainKit
import Movie

protocol MovieListRouterProtocol: AnyObject {
    static func createModule(for section: HomeSectionType) -> UIViewController
    func navigateBack()
    func navigateToMovieDetails(for movie: Movie)
}

final class MovieListRouter: MovieListRouterProtocol {
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    static func createModule(for section: HomeSectionType) -> UIViewController {
        let viewController = MovieListViewController()
        let router = MovieListRouter(viewController: viewController)
        let interactor = MovieListInteractor(section: section)
        let presenter = MovieListPresenter(
            view: viewController,
            interactor: interactor,
            router: router,
            section: section
        )
        
        viewController.presenter = presenter
        interactor.presenter = presenter
        
        return viewController
    }
    
    func navigateBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func navigateToMovieDetails(for movie: Movie) {
        let detailVC = MovieDetailRouter.createModule(for: movie)
        detailVC.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }
}

