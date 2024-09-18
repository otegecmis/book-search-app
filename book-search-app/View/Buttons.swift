import UIKit

class ActionButton: UIButton {
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(backgroundColor: UIColor, title: String) {
        super.init(frame: .zero)
        
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
        configure()
    }
    
    // MARK: - Helpers
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 10
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
    }
    
    func set(backgroundColor: UIColor, title: String) -> Void {
        self.backgroundColor = backgroundColor
        setTitle(title, for: .normal)
    }
}
