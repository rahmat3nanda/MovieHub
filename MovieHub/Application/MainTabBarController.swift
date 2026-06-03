import UIKit
import DesignSystem

public final class MainTabBarController: UITabBarController {
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupTabs()
    }
    
    private func setupTabBar() {
        // Tab Bar Appearance Styling
        tabBar.tintColor = .systemYellow
        tabBar.unselectedItemTintColor = .secondaryLabel
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Colors.background
        
        // Add thin border to separate from screen content
        appearance.shadowColor = UIColor.white.withAlphaComponent(0.08)
        appearance.shadowImage = UIImage()
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
    
    private func setupTabs() {
        // Tab 1: Home
//        let homeVC = HomeViewController()
//        let homeNav = UINavigationController(rootViewController: homeVC)
//        homeNav.setNavigationBarHidden(true, animated: false)
//        homeNav.tabBarItem = UITabBarItem(
//            title: "Home",
//            image: UIImage(systemName: "film"),
//            selectedImage: UIImage(systemName: "film.fill")
//        )
//        
//        // Tab 2: Discover
//        let discoverVC = DiscoverViewController()
//        let discoverNav = UINavigationController(rootViewController: discoverVC)
//        discoverNav.setNavigationBarHidden(true, animated: false)
//        discoverNav.tabBarItem = UITabBarItem(
//            title: "Discover",
//            image: UIImage(systemName: "magnifyingglass"),
//            selectedImage: UIImage(systemName: "magnifyingglass.circle.fill")
//        )
//        
//        // Tab 3: Profile
//        let profileVC = ProfileViewController()
//        let profileNav = UINavigationController(rootViewController: profileVC)
//        profileNav.setNavigationBarHidden(true, animated: false)
//        profileNav.tabBarItem = UITabBarItem(
//            title: "Profile",
//            image: UIImage(systemName: "person"),
//            selectedImage: UIImage(systemName: "person.fill")
//        )
        
//        viewControllers = [homeNav, discoverNav, profileNav]
    }
}
