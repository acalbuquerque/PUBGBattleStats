import UIKit

protocol SearchPlayerRouterInterface {
    func showHUD()
    func dismissHUD(animated: Bool)
    func presentReachabilityAlert(completion: (() -> Void)?)
    func goToPlayerStats(with gameModeStats: GameModeStats, playerName: String, fromViewInterface: SearchPlayerViewInterface)
}

final class SearchPlayerRouter: NSObject, SearchPlayerRouterInterface {
    
    unowned let tabBarController: UITabBarController
    private let hud: HUD
    
    init(tabBarController: UITabBarController,
         hud: HUD = HUD(style: HUD.Style.darkGray)) {
        
        self.tabBarController = tabBarController
        self.hud = hud
    }
    
    func showHUD() {
        hud.show(in: tabBarController.view, animated: true)
    }
    
    func dismissHUD(animated: Bool) {
        hud.dismiss(animated: animated)
    }
    
    func presentReachabilityAlert(completion: (() -> Void)?) {
        
        let alertController = UIAlertController(title: "alert.title.noConnection".localized,
                                                message: "alert.message.noConnection".localized,
                                                preferredStyle: .alert)
        let action = UIAlertAction(title: "alert.ok".localized.uppercased(),
                                   style: .default,
                                   handler: nil)
        alertController.addAction(action)
        
        tabBarController.present(alertController, animated: true, completion: completion)
    }
    
    func goToPlayerStats(with gameModeStats: GameModeStats, playerName: String, fromViewInterface: SearchPlayerViewInterface){
        let gameModeStatsBuilder = GameModesStatsBuilder.build(tabBarController: tabBarController,
                                                               gmStats: gameModeStats,
                                                               playerName: playerName)
        
        let navController = fromViewInterface as? UIViewController
        navController?.navigationController?.pushViewController(gameModeStatsBuilder, animated: true)
    }
}
