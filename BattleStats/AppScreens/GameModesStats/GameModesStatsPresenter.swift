import Foundation

protocol GameModesStatsPresenterInterface: class {
    var router: GameModesStatsRouterInterface { get }
    var view: GameModesStatsViewInterface { get }
    var playerName: String { get }
    func viewDidLoad()
    func saveDeletePlayerFromFavorites()
}

class GameModesStatsPresenter {
    
    unowned let view: GameModesStatsViewInterface
    private let reachable: ReachableInterface
    let router: GameModesStatsRouterInterface
    let gmStats: GameModeStats
    var playerName: String
    
    init(view: GameModesStatsViewInterface,
         router: GameModesStatsRouterInterface,
         playerName: String,
         gameModeStats: GameModeStats,
         reachable: ReachableInterface = Reachable.shared) {
        self.view = view
        self.router = router
        self.playerName = playerName
        self.gmStats = gameModeStats
        self.reachable = reachable
    }
}

extension GameModesStatsPresenter: GameModesStatsPresenterInterface{
    func viewDidLoad() {
        var viewModels: [GameModeTableViewCell.ViewModel] = []
        viewModels.append(self.assembleGMStat(with: "Squad Tpp", gameAttrs: self.gmStats.squad))
        viewModels.append(self.assembleGMStat(with: "Squad Fpp", gameAttrs: self.gmStats.squadFpp))
        viewModels.append(self.assembleGMStat(with: "Duo Tpp", gameAttrs: self.gmStats.duo))
        viewModels.append(self.assembleGMStat(with: "Duo Fpp", gameAttrs: self.gmStats.duoFpp))
        viewModels.append(self.assembleGMStat(with: "Solo Tpp", gameAttrs: self.gmStats.solo))
        viewModels.append(self.assembleGMStat(with: "Solo Fpp", gameAttrs: self.gmStats.soloFpp))
        
        self.view.configure(viewModels: viewModels)
    }
    
    func assembleGMStat(with title: String, gameAttrs: GameAttr) -> GameModeTableViewCell.ViewModel{
        let gameStatsViewModel = GameModeTableViewCell.ViewModel(gmTitle: title,
                                                           longestKill: gameAttrs.longestKill,
                                                           kills: gameAttrs.kills,
                                                           assists: gameAttrs.assists,
                                                           dbnos: gameAttrs.dBNOs,
                                                           rounds: gameAttrs.roundsPlayed,
                                                           top10: gameAttrs.top10s,
                                                           wins: gameAttrs.wins,
                                                           losses: gameAttrs.losses)
        return gameStatsViewModel
    }
    
    func saveDeletePlayerFromFavorites() {
        
    }
}
