import UIKit

final class FavoritesController: UIViewController {
    
    // MARK: - Properties
    enum Section { case main }
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Book>!
    var favorites: [Book] = []
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        getFavorites()
        configureDataSource()
        
        NotificationCenter.default.addObserver(self, selector: #selector(favoritesUpdated), name: NSNotification.Name("FavoritesUpdated"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
        updateData(on: favorites)
    }
    
    // MARK: - Deinitializers
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("FavoritesUpdated"), object: nil)
    }
    
    // MARK: - Helpers
    func configureViewController() {
        self.title = "Favorites"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FavoritesCell.self, forCellWithReuseIdentifier: FavoritesCell.reuseID)
        collectionView.delegate = self
    }
    
    func createThreeColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = availableWidth / 3
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)
        
        return flowLayout
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Book>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, book) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoritesCell.reuseID, for: indexPath) as! FavoritesCell
            cell.set(book: book)
            return cell
        })
    }
    
    func updateData(on followers: [Book]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Book>()
        snapshot.appendSections([.main])
        snapshot.appendItems(favorites)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }
    
    func getFavorites() {
        PersistenceManager.retrieveFavorites { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let favorites):
                self.favorites = favorites
                updateData(on: favorites)
            case .failure(let error):
                self.presentAlertOnMainThread(title: "Error", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    // MARK: - Actions
    @objc func favoritesUpdated() {
        getFavorites()
        updateData(on: favorites)
    }
}

// MARK: - UICollectionViewDelegate
extension FavoritesController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bookController = BookController()
        bookController.book = self.favorites[indexPath.item]
        
        let navController = UINavigationController(rootViewController: bookController)
        present(navController, animated: true)
    }
}
