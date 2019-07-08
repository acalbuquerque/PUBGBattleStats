import Foundation
import RxSwift

protocol PUBGWorkerInterface {
    
    func getAllSeasons(completion: @escaping (Result<[Season]>) -> Void)
    func getPlayerData(with name: String, completion: @escaping (Result<[Player]>) -> Void)
    func getPlayerSeasonData(with playerId: String, seasonId: String, completion: @escaping (Result<PlayerSeason>) -> Void)
}

final class PUBGWorker {
    
    private let environment: Environment
    private let apiClient: PUBGStatsAPIClient
    private let disposeBag = DisposeBag()
    let sessionManager: SessionManager
    
    init(environment: Environment = Environment(),
         apiClient:PUBGStatsAPIClient = PUBGStatsAPIClient(),
         sessionManager: SessionManager = SessionManager()) {
        
        self.environment = environment
        self.apiClient = apiClient
        self.sessionManager = sessionManager
    }
    
    func makeRequest(with urlPathComponents:[String], queryItems:[URLQueryItem]?, and httpMethod:String) throws -> URLRequest {
        
        var urlComponents = URLComponents()
        urlComponents.path = NSString.path(withComponents: urlPathComponents)
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url(relativeTo: apiClient.baseURL()) else {
            throw RequestErrors.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(Constants.apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/vnd.api+json", forHTTPHeaderField: "Accept")
        request.httpMethod = httpMethod
        return request
    }
    
    func loadLocalJSON(filename: String) -> Data? {
        guard let jsonFilePath = Bundle(for: type(of: self)).path(forResource: filename, ofType: "json"),
            let jsonString = try? String(contentsOfFile: jsonFilePath),
            let jsonData = jsonString.data(using: .utf8)
            else { return nil }
        
        return jsonData
    }
}

extension PUBGWorker: PUBGWorkerInterface {
    
    func getAllSeasons(completion: @escaping (Result<[Season]>) -> Void) {
        do {
            let components = [EndpointPath.seasons.rawValue]
            let request = try makeRequest(with: components, queryItems: nil, and: HTTPMethod.get.rawValue)
            
            sessionManager
                .resumeDataTask(forRequest: request)
                .subscribe(onNext: { (response) in
                    
                    switch response.urlResponse.status.responseType {
                    case .success:
                        do {
                            let seasons: SeasonsData = try JSONDecoder().decode(SeasonsData.self, from: response.data)
                            completion(Result<[Season]>.success(seasons.data))
                        } catch let error {
                            completion(Result<[Season]>.failure(error))
                        }
                    default: // server side errors
                        completion(Result<[Season]>.failure(response.urlResponse.status))
                    }
                    
                }, onError: { (error) in
                    completion(Result.failure(error))
                }).disposed(by: disposeBag)
        } catch let error {
            completion(Result.failure(error))
        }
    }
    
    func getPlayerData(with name: String, completion: @escaping (Result<[Player]>) -> Void) {
        do {
            
            let playerNameWithoutPercentEnc = name.replacingOccurrences(of: " ", with: "")
            let queryItemPlayers = URLQueryItem(name: "filter[playerNames]", value: playerNameWithoutPercentEnc)
            
            let components = [EndpointPath.players.rawValue]
            let request = try makeRequest(with: components,
                                          queryItems: [queryItemPlayers],
                                          and: HTTPMethod.get.rawValue)
            
            sessionManager
                .resumeDataTask(forRequest: request)
                .subscribe(onNext: { (response) in
                    
                    switch response.urlResponse.status.responseType {
                    case .success:
                        do {
                            let player: PlayersData = try JSONDecoder().decode(PlayersData.self, from: response.data)
                            completion(Result<[Player]>.success(player.data))
                        } catch let error {
                            completion(Result<[Player]>.failure(error))
                        }
                    default: // server side errors
                        completion(Result<[Player]>.failure(response.urlResponse.status))
                    }
                    
                }, onError: { (error) in
                    completion(Result.failure(error))
                }).disposed(by: disposeBag)
        } catch let error {
            completion(Result.failure(error))
        }
    }
    
    func getPlayerSeasonData(with playerId: String, seasonId: String, completion: @escaping (Result<PlayerSeason>) -> Void){
        do {
            let components = [EndpointPath.players.rawValue, playerId, "seasons", seasonId]
            let request = try makeRequest(with: components,
                                          queryItems: nil,
                                          and: HTTPMethod.get.rawValue)
            sessionManager
                .resumeDataTask(forRequest: request)
                .subscribe(onNext: { (response) in
                    
                    switch response.urlResponse.status.responseType {
                    case .success:
                        do {
                            let playerseason: PlayerSeasonData = try JSONDecoder().decode(PlayerSeasonData.self, from: response.data)
                            completion(Result<PlayerSeason>.success(playerseason.data))
                        } catch let error {
                            completion(Result<PlayerSeason>.failure(error))
                        }
                    default: // server side errors
                        completion(Result<PlayerSeason>.failure(response.urlResponse.status))
                    }
                    
                }, onError: { (error) in
                    completion(Result.failure(error))
                }).disposed(by: disposeBag)
        } catch let error {
            completion(Result.failure(error))
        }
    }
}
