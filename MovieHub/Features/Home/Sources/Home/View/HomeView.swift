import UIKit
import UtilityKit
import DesignSystem

final class HomeView: UIView {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var appBar: HomeAppBarView!
    
    @IBOutlet weak var nowPlayingSection: HomeMovieSectionView!
    @IBOutlet weak var popularSection: HomeMovieSectionView!
    @IBOutlet weak var topRatedSection: HomeMovieSectionView!
    @IBOutlet weak var upcomingSection: HomeMovieSectionView!
    
    // Pull to Refresh
    let refreshControl = UIRefreshControl()
    var onRefresh: (() -> Void)?
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    // MARK: - Setup
    
    private func commonInit() {
        backgroundColor = .background
        
        let rootNibView: UIView = loadViewFromNib(bundle: .module)
        rootNibView.fixInView(self)
        
        // Setup Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshTriggered), for: .valueChanged)
        scrollView.refreshControl = refreshControl
        
        // Configure section titles
        nowPlayingSection.setTitle("Now Playing")
        popularSection.setTitle("Popular")
        topRatedSection.setTitle("Top Rated")
        upcomingSection.setTitle("Upcoming")
    }
    
    @objc private func refreshTriggered() {
        onRefresh?()
    }
}
