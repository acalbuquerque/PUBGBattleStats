import Foundation
import UIKit

class GameModesStatsBuilder {
    static func build(tabBarController: UITabBarController,
                      gmStats: GameModeStats,
                      playerName: String) -> UIViewController {
        let view = GameModesStatsView()
        let router = GameModesStatsRouter(tabBarController: tabBarController)
        let presenter = GameModesStatsPresenter.init(view: view,
                                                    router: router,
                                                    playerName: playerName,
                                                    gameModeStats: gmStats)
        view.presenter = presenter
        return view
    }
}
