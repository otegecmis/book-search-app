import UIKit

fileprivate var containerView: UIView!

// MARK: - UIViewController
extension UIViewController {
    
    // MARK: - Helpers
    func presentAlertOnMainThread(title: String, message: String, buttonTitle: String, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alertVC = AlertViewController(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            alertVC.completion = completion
            self.present(alertVC, animated: true)
        }
    }
}

// MARK: - UITabBarController
extension UITabBarController {
    
    // MARK: - Helpers
    func navigationTabController(title: String, image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        let appearance = UITabBar.appearance()
        
        nav.title = title
        nav.view.backgroundColor = .systemBackground
        nav.tabBarItem.image = image
        nav.tabBarItem.selectedImage?.withTintColor(UIColor.systemRed)
        appearance.tintColor = .systemRed
        
        return nav
    }
}
