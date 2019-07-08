import Foundation

struct NewsAPIClient {
    
    private let environment: EnvironmentInterface
    
    init(environment: EnvironmentInterface = Environment()) {
        self.environment = environment
    }
    
    func baseURL() -> URL {
        
        var url: URL
        
        switch environment.current {
        case .staging:
            url = URL(string: "http://demo6277291.mockable.io")!
        case .production:
            url = URL(string: "http://demo6277291.mockable.io")!
        case .tests:
            url = environment.testAPIBaseURL
        }
        return url
    }
}
