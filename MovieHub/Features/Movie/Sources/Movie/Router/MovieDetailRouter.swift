import UIKit
import DomainKit

public protocol MovieDetailRouterProtocol: AnyObject {
    static func createModule(for movie: Movie) -> UIViewController
    func navigateBack()
}

public final class MovieDetailRouter: MovieDetailRouterProtocol {
    private weak var viewController: UIViewController?

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public static func createModule(for movie: Movie) -> UIViewController {
        let vc = MovieDetailViewController()
        let router = MovieDetailRouter(viewController: vc)
        let interactor = MovieDetailInteractor()
        let presenter = MovieDetailPresenter(
            view: vc,
            interactor: interactor,
            router: router,
            movie: movie
        )

        vc.presenter = presenter
        interactor.presenter = presenter

        return vc
    }

    public func navigateBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
