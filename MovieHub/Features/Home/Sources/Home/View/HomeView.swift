import UIKit
import UtilityKit
import DesignSystem

final class HomeView: UIView {
    
    // MARK: - UI Components
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.alwaysBounceVertical = true
        view.showsVerticalScrollIndicator = true
        return view
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 28
        stack.distribution = .fill
        return stack
    }()
    
    // Sections in order: Now Playing, Popular, Top Rated, Upcoming
    let nowPlayingSection = MovieSectionView(title: "Now Playing")
    let popularSection = MovieSectionView(title: "Popular")
    let topRatedSection = MovieSectionView(title: "Top Rated")
    let upcomingSection = MovieSectionView(title: "Upcoming")
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configUI()
    }
}

fileprivate extension HomeView {
    func configUI() {
        backgroundColor = .background
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        
        // Setup Auto Layout constraints using UtilityKit anchors
        scrollView.anchors.edges.pin()
        contentView.anchors.edges.pin()
        contentView.anchors.width.equal(scrollView.anchors.width)
        
        stackView.anchors.edges.pin(insets: UIEdgeInsets(top: 16, left: 0, bottom: 24, right: 0))
        
        // Add sections in ordered sequence
        stackView.addArrangedSubview(nowPlayingSection)
        stackView.addArrangedSubview(popularSection)
        stackView.addArrangedSubview(topRatedSection)
        stackView.addArrangedSubview(upcomingSection)
    }
}
