import Foundation

protocol SearchPlayerInteractorInterface: class {
    func getSeasons(completion: @escaping (Result<[Season]>) -> Void)
    func getPlayersData(with playerName: String, completion: @escaping (Result<[Player]>) -> Void)
    func getStats(from player: String, inSeasonId: String, completion: @escaping (Result<PlayerSeason>) -> Void)
}

final class SearchPlayerInteractor {
    
    let pubgWorker: PUBGWorkerInterface
    init(pubgWorker: PUBGWorkerInterface = PUBGWorker()) {
        self.pubgWorker = pubgWorker
    }
}

extension SearchPlayerInteractor: SearchPlayerInteractorInterface {
    
    func getSeasons(completion: @escaping (Result<[Season]>) -> Void) {
        pubgWorker.getAllSeasons(completion: completion)
    }
    
    func getPlayersData(with playerName: String, completion: @escaping (Result<[Player]>) -> Void){
        pubgWorker.getPlayerData(with: playerName, completion: completion)
    }
    
    func getStats(from playerId: String, inSeasonId: String, completion: @escaping (Result<PlayerSeason>) -> Void) {
        pubgWorker.getPlayerSeasonData(with: playerId, seasonId: inSeasonId, completion: completion)
    }
}
