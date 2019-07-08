import Foundation

struct PUBGStatsAPIClient {
    
    private let environment: EnvironmentInterface
    
    init(environment: EnvironmentInterface = Environment()) {
        self.environment = environment
    }
    
    func baseURL() -> URL {
        
        var url: URL
        
        switch environment.current {
        case .staging:
            url = URL(string: "https://api.pubg.com/shards/")!
        case .production:
            url = URL(string: "https://api.pubg.com/shards/")!
        case .tests:
            url = environment.testAPIBaseURL
        }
        return url
    }
}
