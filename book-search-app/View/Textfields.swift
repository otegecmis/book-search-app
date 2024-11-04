import UIKit

class SearchTextField: UITextField {
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func configure() {
        
        layer.cornerRadius = 20
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray4.cgColor
        
        textColor = .label
        tintColor = .label
        textAlignment = .center
        font = UIFont.preferredFont(forTextStyle: .title3)
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 10
        
        backgroundColor = .tertiarySystemBackground
        autocorrectionType = .no
        keyboardType = .numbersAndPunctuation
        returnKeyType = .search
        placeholder = "ISBN Number"
        autocapitalizationType = .none
        clearButtonMode = .always
    }
}
