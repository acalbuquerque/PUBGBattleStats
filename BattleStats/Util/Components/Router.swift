import Foundation
import UIKit

protocol ReachableAlertPresenter {
    func showNoConnectionAlert(reachability: ReachableInterface)
    var reachabilityTransitioningDelegate: ReachabilityTransitioningDelegate { get }
}

protocol RouterInterface: class {
    var finishCallback: ((Bool) -> Void)? { get set }
}

protocol AlertPresenter {
    func presentAlert(onViewController viewController: UIViewController,
                      title: String,
                      message: String?,
                      actions: [UIAlertAction]?)
    
    func presentActionSheet(onViewController viewController: UIViewController,
                            title: String?,
                            message: String?,
                            actions: [UIAlertAction]?)
}
extension AlertPresenter {
    
    func presentAlert(onViewController viewController: UIViewController,
                      title: String,
                      message: String? = nil,
                      actions: [UIAlertAction]? = [Self.defaultAction]) {
        
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        
        if let actions = actions {
            for action in actions {
                alertController.addAction(action)
            }
        }
        DispatchQueue.main.async {
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    static var defaultAction: UIAlertAction {
        let actionAlertOk = UIAlertAction(title: "alert.ok".localized,
                                          style: .default,
                                          handler: nil)
        actionAlertOk.accessibilityLabel = "alert.ok.accessibilityLabel".localized
        return actionAlertOk
    }
    
    func presentActionSheet(onViewController viewController: UIViewController,
                            title: String?,
                            message: String? = nil,
                            actions: [UIAlertAction]? = [Self.defaultAction]) {
        
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .actionSheet)
        
        if let actions = actions {
            for action in actions {
                alertController.addAction(action)
            }
        }
        let cancel = UIAlertAction(title: "alert.cancel".localized,
                                   style: .cancel) { (action) in
                                    alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cancel)
        viewController.present(alertController, animated: true, completion: nil)
    }
}
