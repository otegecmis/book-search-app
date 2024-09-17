import UIKit

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
        print("DEBUG: checkIfFavorite()")
    }
    
    func configureUI() {
        guard let book = book else { return }
        
        view.addSubview(bookImageView)
        view.addSubview(tableView)
        
        bookImageView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bookImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            bookImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            bookImageView.heightAnchor.constraint(equalToConstant: 300),
            bookImageView.widthAnchor.constraint(equalToConstant: 200),
            
            tableView.topAnchor.constraint(equalTo: bookImageView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
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
        print("DEBUG: addFavoriteButtonTapped()")
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
