import UIKit

class MainTabController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
    }
    
    func configureViewControllers() {
        view.backgroundColor = .systemBackground
        
        let search = templateNavigationController(title: "Search", image: UIImage(systemName: "magnifyingglass"), rootViewController: SearchController())
        let favorites = templateNavigationController(title: "Favorites", image: UIImage(systemName: "heart"), rootViewController: FavoritesController())
        
        viewControllers = [search, favorites]
    }
    
    func templateNavigationController(title: String, image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        let appearance = UITabBar.appearance()
        
        nav.title = title
        nav.view.backgroundColor = .systemBackground
        nav.tabBarItem.image = image
        nav.tabBarItem.selectedImage?.withTintColor(UIColor.red)
        appearance.tintColor = .systemRed
        
        return nav
    }
}
