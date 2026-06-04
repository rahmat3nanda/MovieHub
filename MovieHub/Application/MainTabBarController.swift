import UIKit
import DesignSystem
import SharedUI
import Home

public final class MainTabBarController: UITabBarController {
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupTabs()
    }
    
    private func setupTabBar() {
        tabBar.tintColor = .secondary
        tabBar.unselectedItemTintColor = .secondaryLabel
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .background
        appearance.shadowColor = UIColor.white.withAlphaComponent(0.08)
        appearance.shadowImage = UIImage()
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
    
    private func setupTabs() {
        // Tab 1: Home (VIPER module assembly)
        let homeVC = HomeRouter.createModule()
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.setNavigationBarHidden(true, animated: false)
        homeNav.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )

        // Tab 2: Discover
        let discoverVC = DevelopmentViewController()
        let discoverNav = UINavigationController(rootViewController: discoverVC)
        discoverNav.setNavigationBarHidden(true, animated: false)
        discoverNav.tabBarItem = UITabBarItem(
            title: "Discover",
            image: UIImage(systemName: "safari"),
            selectedImage: UIImage(systemName: "safari.fill")
        )
        
        // Tab 3: Profile
        let profileVC = DevelopmentViewController()
        let profileNav = UINavigationController(rootViewController: profileVC)
        profileNav.setNavigationBarHidden(true, animated: false)
        profileNav.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        
        viewControllers = [homeNav, discoverNav, profileNav]
    }
}
