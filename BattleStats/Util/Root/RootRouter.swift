import UIKit

protocol RootRouterInterface: class {
    func start()
}

class RootRouter: RootRouterInterface {
    
    unowned let viewController: RootNavigationController
    
    let reachable: Reachable
    let hud: HUD
    
    init(window: UIWindow,
         viewController: RootNavigationController,
         reachable: Reachable = Reachable.shared,
         hud: HUD = HUD()) {
        
        self.viewController = viewController
        self.reachable = reachable
        self.hud = hud
        
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
    
    func start() {

        var viewControllers: [UIViewController] = []
        let tabBarController = HomeTabBarController(communityRouterDelegate: self)
        viewControllers = [tabBarController]
        viewController.setNavigationBarHidden(true, animated: false)
        viewController.setViewControllers(viewControllers, animated: true)
    }
    
    func navigationControllerFromWindow(_ window: UIWindow) -> UINavigationController {
        let navigationController = window.rootViewController as! UINavigationController
        return navigationController
    }
}

extension RootRouter: CommunityNewsRouterInterface{

    func showHUD() {
        hud.show(in: self.viewController.view)
    }
    
    func dismissHUD(animated: Bool) {
        hud.dismiss(animated: animated)
    }
    
    func presentReachabilityAlert(completion: (() -> Void)?) {
    }
    
    func goToNews(fromViewInterface: CommunityNewsViewInterface, news: News) {
    }
}
