import UIKit

class RootNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    override var childViewControllerForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
}
