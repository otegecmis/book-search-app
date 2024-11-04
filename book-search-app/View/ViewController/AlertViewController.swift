import UIKit
import SnapKit

class AlertViewController: UIViewController {
    
    // MARK: - Properties
    let containerView = UIView()
    let titleLabel = TitleLabel(textAlignment: .center, fontSize: 20)
    let messageLabel = BodyLabel(textAlignment: .center)
    let actionButton = ActionButton(backgroundColor: .systemRed, title: "Ok")
    
    var alertTitle: String?
    var message: String?
    var buttonTitle: String?
    var completion: (() -> Void)?
    
    var padding: CGFloat = 20
    
    // MARK: - Initializers
    init(title: String, message: String, buttonTitle: String) {
        super.init(nibName: nil, bundle: nil)
        
        self.alertTitle = title
        self.message = message
        self.buttonTitle = buttonTitle
        
        configureContainerView()
        configureTitleLabel()
        configureActionButton()
        configureMessageLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
    }
    
    // MARK: - Helpers
    func configureContainerView() -> Void {
        view.addSubview(containerView)
        
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 16
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor.white.cgColor
        
        containerView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(280)
            make.height.equalTo(220)
        }
    }
    
    func configureTitleLabel() -> Void {
        containerView.addSubview(titleLabel)
        titleLabel.text = alertTitle ?? "Error"
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.top).offset(padding)
            make.leading.equalTo(containerView.snp.leading).offset(padding)
            make.trailing.equalTo(containerView.snp.trailing).inset(padding)
            make.height.equalTo(28)
        }
    }
    
    func configureActionButton() -> Void {
        containerView.addSubview(actionButton)
        actionButton.setTitle(buttonTitle ?? "Ok", for: .normal)
        
        actionButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        actionButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(padding)
            make.leading.equalToSuperview().offset(padding)
            make.trailing.equalToSuperview().inset(padding)
            make.height.equalTo(44)
        }
    }
    
    func configureMessageLabel() -> Void {
        containerView.addSubview(messageLabel)
        messageLabel.text = message ?? "Error"
        messageLabel.numberOfLines = 4

        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(containerView.snp.leading).offset(padding)
            make.trailing.equalTo(containerView.snp.trailing).inset(padding)
            make.bottom.equalTo(actionButton.snp.top).offset(-12)
        }
    }
    
    // MARK: - Actions
    @objc func dismissVC() {
        dismiss(animated: true) {
            self.completion?()
        }
    }
}

