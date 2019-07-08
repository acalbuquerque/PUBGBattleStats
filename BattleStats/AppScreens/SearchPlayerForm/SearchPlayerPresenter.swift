import Foundation
import UIKit

protocol SearchPlayerPresenterInterface: class {
    
    var interactor: SearchPlayerInteractorInterface { get }
    var router: SearchPlayerRouterInterface { get }
    var view: SearchPlayerViewInterface { get }
    
    func viewDidLoad()    
    func showStats(with playerName:String, season: String)
}

class SearchPlayerPresenter: AlertPresenter {
    
    unowned let view: SearchPlayerViewInterface
    private let reachable: ReachableInterface
    let router: SearchPlayerRouterInterface
    var interactor: SearchPlayerInteractorInterface
    var seasonItems =  [Season]()
    var seasonViewModels = [SeasonViewModel.ViewModel]()
    
    init(view: SearchPlayerViewInterface,
         interactor: SearchPlayerInteractorInterface,
         router: SearchPlayerRouterInterface,
         reachable: ReachableInterface = Reachable.shared) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.reachable = reachable
    }
}

extension SearchPlayerPresenter: SearchPlayerPresenterInterface{
    
    func viewDidLoad() {
        router.showHUD()
        interactor.getSeasons { (result) in
            self.router.dismissHUD(animated: true)
            
            switch result {
            case .success(let items):
                self.seasonItems = items.suffix(5) // last 5
                
                let viewModels = self.seasonItems.map({ (data) -> SeasonViewModel.ViewModel in
                    return SeasonViewModel.ViewModel.init(title: data.id,
                                                          isCurrentSeason: data.attributes?.isCurrentSeason ?? false)
                })
                self.seasonViewModels = viewModels
                self.view.setupForm(with: self.seasonViewModels)
            case .failure(let error):
                if let httpStatusCode = error as? HTTPStatusCode,
                    httpStatusCode == .unauthorized {
                    self.presentAlert(onViewController: self.view as! UIViewController,
                                      title: String(format:"alert.message.error.unauthorized".localized, error.localizedDescription))
                }
                else{
                    self.presentAlert(onViewController: self.view as! UIViewController,
                                      title: String(format:"alert.message.generalError".localized, error.localizedDescription))
                }
            }
        }
    }
    
    func showStats(with playerName:String, season: String) {
        
        if !reachable.isInternetAvailable {
            router.presentReachabilityAlert(completion: nil)
            return
        }
        
        router.showHUD()
        
        guard let seasonIndex = self.seasonViewModels.firstIndex(where: { $0.newTitle.hasPrefix(season) }) else{
            fatalError("season index not found")
        }
        ////////////////////////////////////
        // Get PlayerData for next request
        ////////////////////////////////////
        interactor.getPlayersData(with: playerName) { (playerResult) in
            
            let seasonId = self.seasonItems[seasonIndex].id
            
            switch playerResult {
            case .success(let playerData):

                guard let player = playerData.first else { // must have a player
                    fatalError("first player not found")
                }
                //////////////////////////
                // Get PlayerSeason Stats
                //////////////////////////
                self.interactor.getStats(from: player.id, inSeasonId: seasonId, completion: { (psResult) in
                    switch psResult {
                    case .success(let playerSeason):
                        self.router.dismissHUD(animated: true)
                        let gmStats = playerSeason.attributes.gameModeStats
                        self.router.goToPlayerStats(with: gmStats, playerName: playerName, fromViewInterface: self.view)
                    case .failure(let error):
                        
                        if let httpStatusCode = error as? HTTPStatusCode,
                            httpStatusCode == .notFound {
                            self.presentAlert(onViewController: self.view as! UIViewController,
                                              title: "alert.message.error.notFound".localized)
                        }
                        else {
                            self.presentAlert(onViewController: self.view as! UIViewController,
                                              title: String(format:"alert.message.generalError".localized, error.localizedDescription))
                        }
                    }
                })
                //////////////////////////
            case .failure(let error):
                self.router.dismissHUD(animated: true)
                if let httpStatusCode = error as? HTTPStatusCode,
                    httpStatusCode == .notFound {
                    self.presentAlert(onViewController: self.view as! UIViewController,
                                      title: "alert.message.error.notFound".localized)
                }
                else {
                    self.presentAlert(onViewController: self.view as! UIViewController,
                                      title: String(format:"alert.message.generalError".localized, error.localizedDescription))
                }
            }
        }
        
    }
}


class SeasonViewModel{
    
    struct ViewModel {
        let newTitle:String
        init(title: String, isCurrentSeason: Bool){

            let titleSplitedArr = title.components(separatedBy: ".")
            guard let titlePeriod = titleSplitedArr.last else{
                fatalError("season without period")
            }
            if isCurrentSeason {
                self.newTitle = "Current (" + titlePeriod + ")"
            }
            else {
                self.newTitle = titlePeriod
            }
        }
    }
}
