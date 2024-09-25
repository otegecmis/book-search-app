import UIKit

class MainTabController: UITabBarController {
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
    }
    
    // MARK: - Helpers
    func configureViewControllers() {
        view.backgroundColor = .systemBackground
        
        let search = navigationTabController(title: "Search", image: UIImage(systemName: "magnifyingglass"), rootViewController: SearchController())
        let favorites = navigationTabController(title: "Favorites", image: UIImage(systemName: "heart"), rootViewController: FavoritesController())
        
        viewControllers = [search, favorites]
    }
}

@available(iOS 17.0, *)
#Preview {
    return MainTabController()
}
