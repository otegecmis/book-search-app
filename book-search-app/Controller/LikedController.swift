import UIKit

class LikedController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        title = "Liked"
    }
}
