import UIKit

protocol BaseViewControllerInterface: class {
    func showHudAnimated(_ animated: Bool)
    func dismissHudAnimated(_ animated: Bool)
    func showError(title: String?, message: String?)
}

class BaseViewController: UIViewController, AlertPresenter {
    let hud = HUD(style: .darkGray)
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showHudAnimated(_ animated: Bool) {
        if let view = self.navigationController?.view {
            hud.show(in: view, animated: true)
        } else if let view = self.view {
            hud.show(in: view, animated: true)
        }
    }
    
    func dismissHudAnimated(_ animated: Bool) {
        hud.dismiss(animated: animated)
    }
    
    func showError(title: String?, message: String?) {
        presentAlert(onViewController: self, title: title ?? "", message: message)
    }
}
