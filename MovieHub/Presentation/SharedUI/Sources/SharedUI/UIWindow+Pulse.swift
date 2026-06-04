#if DEBUG
import UIKit
import SwiftUI
import PulseUI

extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
        
        if motion == .motionShake {
            presentPulseConsole()
        }
    }
    
    private func presentPulseConsole() {
        guard let topVC = topViewController() else { return }
        
        // Prevent presenting multiple overlay instances of the console
        if String(describing: type(of: topVC)).contains("UIHostingController") {
            return
        }
        
        let consoleView = ConsoleView()
        let hostingController = UIHostingController(rootView: NavigationView { consoleView })
        hostingController.modalPresentationStyle = .fullScreen
        topVC.present(hostingController, animated: true, completion: nil)
    }
    
    private func topViewController(base: UIViewController? = nil) -> UIViewController? {
        let baseVC = base ?? rootViewController
        
        if let nav = baseVC as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = baseVC as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = baseVC?.presentedViewController {
            return topViewController(base: presented)
        }
        return baseVC
    }
}
#endif
