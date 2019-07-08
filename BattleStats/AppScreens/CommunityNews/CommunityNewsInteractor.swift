import Foundation

protocol CommunityNewsInteractorInterface: class {
    func getNews(completion: @escaping (Result<[News]>) -> Void)
}

final class CommunityNewsInteractor {
    
    let communityWorker: CommunityNewsWorkerInterface
    init(communityWorker: CommunityNewsWorkerInterface = CommunityNewsWorker()) {
        self.communityWorker = communityWorker
    }
}

extension CommunityNewsInteractor: CommunityNewsInteractorInterface {
    
    func getNews(completion: @escaping (Result<[News]>) -> Void) {
        communityWorker.getNews(completion: completion)
    }
}

