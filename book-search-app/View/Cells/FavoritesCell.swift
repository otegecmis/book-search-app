import UIKit
import SnapKit

class FavoritesCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let reuseID = "FavoritesCell"
    let bookCoverImageView = BookCoverImageView(frame: .zero)
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    func set(book: Book) {
        bookCoverImageView.downloadImage(from: book.image)
    }
    
    private func configure() {
        addSubview(bookCoverImageView)
        let padding: CGFloat = 8
        
        bookCoverImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(padding)
            make.leading.equalToSuperview().offset(padding)
            make.trailing.equalToSuperview().inset(padding)
            make.height.equalTo(bookCoverImageView.snp.width).multipliedBy(1.5)
        }
    }
}
