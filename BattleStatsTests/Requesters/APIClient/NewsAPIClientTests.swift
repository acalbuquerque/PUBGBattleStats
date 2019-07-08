import XCTest
@testable import BattleStats

class NewsAPIClientTests: XCTestCase {
    
    var newsAPIClient: NewsAPIClient?
    var environment: MockEnvironment!

    override func setUp() {
        super.setUp()
        environment = MockEnvironment(bundle: Bundle.main,
                                      userDefaults: UserDefaults.standard,
                                      fileManager: FileManager(),
                                      processInfo: ProcessInfo.processInfo)
        
        newsAPIClient = NewsAPIClient(environment: environment)
    }

    override func tearDown() {
        super.tearDown()
        newsAPIClient = nil
    }
    
    func testBaseURL_Staging(){
        environment.current = .staging
        let expectedURL = URL(string: "http://demo6277291.mockable.io")!
        XCTAssertEqual(newsAPIClient?.baseURL(), expectedURL)
    }
    
    func testBaseURL_Production() {
        environment.current = .production
        let expectedURL = URL(string: "http://demo6277291.mockable.io")!
        XCTAssertEqual(newsAPIClient?.baseURL(), expectedURL)
    }
    
    func testBaseURL_Tests() {
        environment.current = .tests
        let expectedURL = URL(string: "http://127.0.0.1:8080")!
        XCTAssertEqual(newsAPIClient?.baseURL(), expectedURL)
    }

}

class MockEnvironment: EnvironmentInterface {
    
    var bundle: Bundle
    var userDefaults: UserDefaults
    var fileManager: FileManager
    var processInfo: ProcessInfoInterface
    
    var testAPIBaseURL: URL = URL(string: "http://127.0.0.1:8080")!
    var current: Environment.EnvType = .staging
    var enableRequestLogs: Bool = false
    
    required init(bundle: Bundle,
                  userDefaults: UserDefaults,
                  fileManager: FileManager,
                  processInfo: ProcessInfoInterface) {
        
        self.bundle = bundle
        self.userDefaults = userDefaults
        self.fileManager = fileManager
        self.processInfo = processInfo
    }
}
