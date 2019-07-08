import Foundation
import UIKit

protocol RootBuilderInterface {
    func build(withWindow window: UIWindow) -> RootRouterInterface
}

class RootBuilder: RootBuilderInterface {
    
    func build(withWindow window: UIWindow) -> RootRouterInterface {
        
        let storyboard = UIStoryboard(name: "RootNavigation", bundle: nil)
        guard let navigationViewController = storyboard.instantiateInitialViewController() as? RootNavigationController else {
            fatalError("Expected RootNavigation Storyboard to return navigation controller")
        }
        
        let router = RootRouter(window: window,
                                viewController: navigationViewController)
        
        return router
    }
}
