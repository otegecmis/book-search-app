import UIKit

final class SearchController: UIViewController {
    let logoImageView = UIImageView()
    let searchTextField = SearchTextField()
    let searchButton = ActionButton(backgroundColor: .systemRed, title: "Search")
    
    var isIsbnEntered: Bool {
        return !searchTextField.text!.isEmpty
    }
    
    let containerView = UIView()
    var containerViewCenterYConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureUI()
        createDismissKeyboardTapGesture()
        configureKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = nil
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .systemRed
    }
    
    @objc func searchBook() {
        print("DEBUG: searchBook()")
    }
    
    func configureUI() {
        view.addSubview(containerView)
        
        containerView.addSubview(logoImageView)
        containerView.addSubview(searchTextField)
        containerView.addSubview(searchButton)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        if let logoImage = UIImage(named: "Logo") {
            logoImageView.image = logoImage
        } else {
            logoImageView.image = nil
            logoImageView.backgroundColor = .gray
        }
        
        logoImageView.contentMode = .scaleAspectFill
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            
            searchTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 25),
            searchTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            searchTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            searchTextField.heightAnchor.constraint(equalToConstant: 50),
            
            searchButton.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            searchButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            searchButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            searchButton.heightAnchor.constraint(equalToConstant: 50),
            searchButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        containerViewCenterYConstraint = containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerViewCenterYConstraint,
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        searchTextField.delegate = self
        searchButton.addTarget(self, action: #selector(searchBook), for: .touchUpInside)
    }
}
