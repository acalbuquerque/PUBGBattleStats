import XCTest
@testable import BattleStats

class PubgAPIClientTests: XCTestCase {
    
    var pubgAPIClient: PUBGStatsAPIClient?
    var environment: MockEnvironment!
    
    override func setUp() {
        super.setUp()
        environment = MockEnvironment(bundle: Bundle.main,
                                      userDefaults: UserDefaults.standard,
                                      fileManager: FileManager(),
                                      processInfo: ProcessInfo.processInfo)
        
        pubgAPIClient = PUBGStatsAPIClient(environment: environment)
    }
    
    override func tearDown() {
        super.tearDown()
        pubgAPIClient = nil
    }
    
    func testBaseURL_Staging(){
        environment.current = .staging
        let expectedURL = URL(string: "https://api.pubg.com/shards/")!
        XCTAssertEqual(pubgAPIClient?.baseURL(), expectedURL)
    }
    
    func testBaseURL_Production() {
        environment.current = .production
        let expectedURL = URL(string: "https://api.pubg.com/shards/")!
        XCTAssertEqual(pubgAPIClient?.baseURL(), expectedURL)
    }
    
    func testBaseURL_Tests() {
        environment.current = .tests
        let expectedURL = URL(string: "http://127.0.0.1:8080")!
        XCTAssertEqual(pubgAPIClient?.baseURL(), expectedURL)
    }
}
