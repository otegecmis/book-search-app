import UIKit
import SnapKit

final class BookController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    var bookImageView = BookCoverImageView(frame: .zero)
    var tableView = UITableView()
    
    var book: Book?
    var bookInformations: [[String]] = []
    
    var isFavorite: Bool = false {
        didSet {
            updateFavoriteButton()
        }
    }
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
        configureUI()
        checkIfFavorite()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Helpers
    func configureViewController() {
        title = "Book View"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let favoriteButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .done, target: self, action: #selector(addFavoriteButtonTapped))
        navigationItem.rightBarButtonItem = favoriteButton
        navigationItem.rightBarButtonItem?.tintColor = .systemRed
    }
    
    func updateFavoriteButton() {
        let buttonImageName = isFavorite ? "heart.fill" : "heart"
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: buttonImageName)
    }
    
    func checkIfFavorite() {
        guard let favorite = self.book else { return }
        
        PersistenceManager.isFavorite(book: favorite) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let isFavorite):
                self.isFavorite = isFavorite
            case .failure(let error):
                self.presentAlertOnMainThread(title: "Error", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    func configureUI() {
        guard let book = book else { return }
        
        view.addSubview(bookImageView)
        view.addSubview(tableView)
        
        bookImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
            make.height.equalTo(300)
            make.width.equalTo(200)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(bookImageView.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
        
        bookInformations.append(contentsOf: [
            ["Title", book.title],
            ["Author", book.author],
            ["Publisher", book.publisher],
            ["ISBN-10", book.isbn10],
            ["ISBN-13", book.isbn13],
            ["Published", book.published]
        ])
        
        bookImageView.downloadImage(from: book.image)
    }
    
    // MARK: - Actions
    @objc func addFavoriteButtonTapped() {
        guard let favorite = self.book else { return }
        let actionType: PersistenceActionType = isFavorite ? .remove : .add
        
        PersistenceManager.updateWith(favorite: favorite, actionType: actionType) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else {
                self.isFavorite.toggle()
                NotificationCenter.default.post(name: NSNotification.Name("FavoritesUpdated"), object: nil)
                return
            }
            
            self.presentAlertOnMainThread(title: "Error", message: error.rawValue, buttonTitle: "Ok")
        }
    }
}

// MARK: - UITableViewDataSource
extension BookController {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Information"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookInformations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        
        cell.textLabel?.text = bookInformations[indexPath.row][1]
        cell.detailTextLabel?.text = bookInformations[indexPath.row][0]
        cell.selectionStyle = .none
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension BookController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
}
