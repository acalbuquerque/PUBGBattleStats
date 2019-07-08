import Foundation
import RxSwift

protocol CommunityNewsWorkerInterface {
    func getNews(completion: @escaping (Result<[News]>) -> Void)
}

final class CommunityNewsWorker {
    
    private let environment: Environment
    private let apiClient: NewsAPIClient
    private let disposeBag = DisposeBag()
    let sessionManager: SessionManager
    
    init(environment: Environment = Environment(),
         apiClient: NewsAPIClient = NewsAPIClient(),
         sessionManager: SessionManager = SessionManager()){
        
        self.environment = environment
        self.apiClient = apiClient
        self.sessionManager = sessionManager
    }
    
    func makeRequest() throws -> URLRequest { // TODO: for a future request
        
        let components = [EndpointPath.news.rawValue]
        var urlComponents = URLComponents()
        urlComponents.path = NSString.path(withComponents: components)
        
        guard let url = urlComponents.url(relativeTo: apiClient.baseURL()) else {
            throw RequestErrors.invalidURL
        }
        let request = URLRequest(url: url)
        return request
    }
}

extension CommunityNewsWorker: CommunityNewsWorkerInterface {
    
    func getNews(completion: @escaping (Result<[News]>) -> Void) {
        
        do {
            let request = try makeRequest()
            
            sessionManager
            .resumeDataTask(forRequest: request)
                .subscribe(onNext: { (response) in
                    
                    switch response.urlResponse.status.responseType {
                    case .clientError:
                        switch (response.urlResponse.status) {
                        case .unauthorized:
                            // TODO: SESSION LOGOUT
                            self.sessionManager.invalidateSession()
                        default:
                            completion(Result<[News]>.failure(response.urlResponse.status))
                        }
                    case .success:
                        do {
                            let news = try JSONDecoder().decode([News].self, from: response.data)
                            completion(Result<[News]>.success(news))
                        } catch let error {
                            completion(Result<[News]>.failure(error))
                        }
                    default:
                        completion(Result<[News]>.failure(response.urlResponse.status))
                    }
                }, onError: { (error) in
                    completion(Result.failure(error))
                }).disposed(by: disposeBag)
        } catch let error {
            completion(Result.failure(error))
        }
    }
}
