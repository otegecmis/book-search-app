import UIKit

fileprivate var containerView: UIView!

extension UIViewController {
    
    // MARK: - Helpers
    func presentAlertOnMainThread(title: String, message: String, buttonTitle: String, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alertVC = AlertViewController(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            alertVC.completion = completion
            self.present(alertVC, animated: true)
        }
    }
}
