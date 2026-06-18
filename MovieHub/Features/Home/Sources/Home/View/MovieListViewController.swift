import UIKit
import DomainKit
import SharedUI
import DesignSystem

enum MovieListUIState {
    case loading
    case loaded([Movie])
    case empty
    case error(Error)
}

protocol MovieListViewProtocol: AnyObject {
    func showState(_ state: MovieListUIState)
    func updateMovies(_ movies: [Movie])
    func showPaginationLoading(_ isLoading: Bool)
}

final class MovieListViewController: UIViewController {
    
    var presenter: MovieListPresenterProtocol?
    
    private var movies: [Movie] = []
    private var isPaginationLoading = false
    private var isFirstLoadLoading = true
    
    private var movieListView: MovieListView {
        guard let customView = view as? MovieListView else {
            fatalError("Expected view of type MovieListView")
        }
        return customView
    }
    
    override func loadView() {
        view = MovieListView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupListeners()
        presenter?.viewDidLoad()
    }
    
    private func setupCollectionView() {
        movieListView.collectionView.dataSource = self
        movieListView.collectionView.delegate = self
        
        movieListView.collectionView.registerCell(MovieItemCell.self)
        movieListView.collectionView.register(
            UINib(nibName: "MovieListHeaderView", bundle: .module),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: MovieListHeaderView.reuseIdentifier
        )
        movieListView.collectionView.register(
            UINib(nibName: "LoadingFooterView", bundle: .module),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: LoadingFooterView.reuseIdentifier
        )
    }
    
    private func setupListeners() {
        movieListView.onBackTapped = { [weak self] in
            self?.presenter?.backTapped()
        }
        
        movieListView.onSearchTapped = { [weak self] in
            self?.presenter?.searchTapped()
        }
        
        movieListView.onRetryTapped = { [weak self] in
            self?.presenter?.retryTapped()
        }
        
        movieListView.onRefresh = { [weak self] in
            self?.presenter?.pullToRefresh()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if navigationController?.interactivePopGestureRecognizer?.delegate === self {
            navigationController?.interactivePopGestureRecognizer?.delegate = nil
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        movieListView.collectionView.collectionViewLayout.invalidateLayout()
    }
}

// MARK: - UIGestureRecognizerDelegate

extension MovieListViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return (navigationController?.viewControllers.count ?? 0) > 1
    }
}

// MARK: - UICollectionViewDataSource

extension MovieListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFirstLoadLoading {
            return 6
        }
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MovieItemCell = collectionView.dequeueReusableCell(for: indexPath)
        
        if isFirstLoadLoading {
            cell.configure(with: nil, isLoading: true)
        } else {
            guard indexPath.item < movies.count else {
                cell.configure(with: nil, isLoading: true)
                return cell
            }
            let movie = movies[indexPath.item]
            cell.configure(with: movie, isLoading: false)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: MovieListHeaderView.reuseIdentifier,
                for: indexPath
            ) as? MovieListHeaderView else {
                return UICollectionReusableView()
            }
            header.configure(with: presenter?.title ?? "")
            return header
            
        case UICollectionView.elementKindSectionFooter:
            guard let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: LoadingFooterView.reuseIdentifier,
                for: indexPath
            ) as? LoadingFooterView else {
                return UICollectionReusableView()
            }
            footer.setAnimating(isPaginationLoading)
            return footer
            
        default:
            return UICollectionReusableView()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MovieListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !isFirstLoadLoading else { return }
        guard indexPath.item < movies.count else { return }
        let movie = movies[indexPath.item]
        presenter?.movieSelected(movie)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let horizontalSpacing: CGFloat = 16 * 3
        let itemWidth = (width - horizontalSpacing) / 2
        let itemHeight = itemWidth * 1.7
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return isPaginationLoading ? CGSize(width: collectionView.bounds.width, height: 50) : .zero
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height - 200 {
            presenter?.loadMoreMovies()
        }
    }
}

// MARK: - MovieListViewProtocol

extension MovieListViewController: MovieListViewProtocol {
    
    func showState(_ state: MovieListUIState) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.movieListView.refreshControl.endRefreshing()
            
            switch state {
            case .loading:
                self.isFirstLoadLoading = true
                self.movies = []
                self.movieListView.showNormalState()
                self.movieListView.collectionView.reloadData()
                
            case .loaded(let movies):
                self.isFirstLoadLoading = false
                self.movies = movies
                self.movieListView.showNormalState()
                self.movieListView.collectionView.reloadData()
                
            case .empty:
                self.isFirstLoadLoading = false
                self.movies = []
                self.movieListView.showEmptyState(true)
                
            case .error(let error):
                self.isFirstLoadLoading = false
                self.movies = []
                self.movieListView.showErrorState(error)
            }
        }
    }
    
    func updateMovies(_ movies: [Movie]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.movies = movies
            self.movieListView.collectionView.reloadData()
        }
    }
    
    func showPaginationLoading(_ isLoading: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.isPaginationLoading = isLoading
            self.movieListView.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
}
