import UIKit
import SnapKit

final class SearchController: UIViewController {
    
    // MARK: - Properties
    let logoImageView = UIImageView()
    let searchTextField = SearchTextField()
    let searchButton = ActionButton(backgroundColor: .systemRed, title: "Search")
    
    var isIsbnEntered: Bool {
        return !searchTextField.text!.isEmpty
    }
    
    let containerView = UIView()
    var containerViewCenterYConstraint: Constraint?
    
    // MARK: - Lifecycles
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
    
    // MARK: - Helpers
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .systemRed
    }
    
    func configureUI() {
        view.addSubview(containerView)
        
        containerView.addSubview(logoImageView)
        containerView.addSubview(searchTextField)
        containerView.addSubview(searchButton)
        
        if let logoImage = UIImage(named: "Logo") {
            logoImageView.image = logoImage
        } else {
            logoImageView.image = nil
            logoImageView.backgroundColor = .gray
        }
        
        logoImageView.contentMode = .scaleAspectFill
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.top)
            make.centerX.equalTo(containerView.snp.centerX)
            make.height.equalTo(100)
            make.width.equalTo(100)
        }
        
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(25)
            make.leading.equalTo(containerView.snp.leading)
            make.trailing.equalTo(containerView.snp.trailing)
            make.height.equalTo(50)
        }
        
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(10)
            make.leading.equalTo(containerView.snp.leading)
            make.trailing.equalTo(containerView.snp.trailing)
            make.height.equalTo(50)
            make.bottom.equalTo(containerView.snp.bottom)
        }
        
        containerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            containerViewCenterYConstraint = make.centerY.equalToSuperview().constraint
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        
        searchTextField.delegate = self
        searchButton.addTarget(self, action: #selector(searchBook), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc func searchBook() {
        guard isIsbnEntered else {
            self.presentAlertOnMainThread(title: "Error", message: "Please enter a valid ISBN number to proceed with your search.", buttonTitle: "Ok")
            return
        }
        
        guard let isbn = searchTextField.text else { return }
        let trimmedISBN = isbn.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let isbn10Pattern = "^(?:\\d{9}X|\\d{10})$"
        let isbn13Pattern = "^\\d{13}$"
        
        let isValidISBN10 = trimmedISBN.range(of: isbn10Pattern, options: .regularExpression) != nil
        let isValidISBN13 = trimmedISBN.range(of: isbn13Pattern, options: .regularExpression) != nil
        
        guard isValidISBN10 || isValidISBN13 else {
            self.presentAlertOnMainThread(title: "Error", message: "Please enter a valid ISBN-10 or ISBN-13 number.", buttonTitle: "Ok")
            return
        }
        
        let url = API_URL + "\(trimmedISBN)"
        
        APIService.shared.request(url, method: .get, parameters: nil, responseType: Book.self) { result in
            switch result {
            case .success(let book):
                DispatchQueue.main.async {
                    let bookController = BookController()
                    bookController.book = book
                    self.navigationController?.pushViewController(bookController, animated: true)
                }
            case .failure( _):
                self.presentAlertOnMainThread(title: "Not Found", message: "The book was not found.\nPlease verify the ISBN and try again.", buttonTitle: "Ok")
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension SearchController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBook()
        return true
    }
}

// MARK: - Keyboard Handling
extension SearchController {
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    func configureKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let keyboardHeight = keyboardSize.height
        
        containerViewCenterYConstraint?.update(offset: -keyboardHeight / 2)
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        containerViewCenterYConstraint?.update(offset: 0)
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
