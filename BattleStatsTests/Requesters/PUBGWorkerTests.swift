import XCTest
@testable import BattleStats

class PUBGWorkerTests: XCTestCase {
    
    let interactor = SearchPlayerInteractor()
    lazy var mockedSeasons: [Season] = {
        let seasonsJson = JSONLoader().loadJSON(filename: "Seasons")!
        let seasons = try! JSONDecoder().decode(Array<Season>.self, from: seasonsJson)
        return seasons
    }()
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMakeRequestSeasons() {
        let pubgWorker = PUBGWorker()
        
        let components = [EndpointPath.seasons.rawValue]
        
        let request = try! pubgWorker.makeRequest(with: components, queryItems: nil, and: HTTPMethod.get.rawValue)
        
        XCTAssertEqual(request.url!, URL(string: "http://127.0.0.1:8080/steam/seasons")!)
        XCTAssertEqual(request.allHTTPHeaderFields?["Authorization"], "Bearer \(Constants.apiKey)")
    }
    
    func testMakeRequestPlayerInfo() {
        let pubgWorker = PUBGWorker()
        
        let playerNameWithoutPercentEnc = "Netenho".replacingOccurrences(of: " ", with: "")
        let queryItemPlayers = URLQueryItem(name: "filter[playerNames]", value: playerNameWithoutPercentEnc)
        let components = [EndpointPath.players.rawValue]
        
        let request = try! pubgWorker.makeRequest(with: components, queryItems: [queryItemPlayers], and: HTTPMethod.get.rawValue)
        
        XCTAssertEqual(request.url!, URL(string: "http://127.0.0.1:8080/steam/players?filter[playerNames]=Netenho")!)
        XCTAssertEqual(request.allHTTPHeaderFields?["Authorization"], "Bearer \(Constants.apiKey)")
    }
    
    func testParseSeasonsModel() {
        let json = JSONLoader().loadJSON(filename: "Seasons")!
        do {
            let mockedSeasons = try JSONDecoder().decode(SeasonsData.self, from: json)
            XCTAssertNotNil(mockedSeasons.data, "Seasons can not be nil")
            
            for item in mockedSeasons.data {
                XCTAssertNotNil(item.id)
                XCTAssertNotNil(item.type)
                
                if let attrs = item.attributes {
                    XCTAssertNotNil(attrs.isCurrentSeason, "Must be a Bool")
                    XCTAssertNotNil(attrs.isOffseason, "Must be a Bool")
                }
            }
        } catch let error as DecodingError {
            XCTFail(error.errorDescription ?? "DecodingError")
        } catch let error {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testParsePlayerModel() {
        let json = JSONLoader().loadJSON(filename: "PlayerInfo")!
        do {
            let mockedPlayer = try JSONDecoder().decode(PlayersData.self, from: json)
            XCTAssertNotNil(mockedPlayer.data, "PlayerInfo can not be nil")
            
            for item in mockedPlayer.data {
                XCTAssertNotNil(item.id)
                XCTAssertNotNil(item.type)
                XCTAssertNotNil(item.attributes)
                XCTAssertNotNil(item.relationships)
                //
                XCTAssertNotNil(item.attributes.name)
                XCTAssertNotNil(item.attributes.shardId)
                XCTAssertNotNil(item.attributes.createdAt)
            }
        } catch let error as DecodingError {
            XCTFail(error.errorDescription ?? "DecodingError")
        } catch let error {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testGetAllSeasons() {
        
        self.interactor.getSeasons { (result) in
            switch result {
                case .success(let seasons):
                XCTAssertNotNil(seasons, "Seasons can not be nil")
                
                let firstSeason = seasons.first!
                XCTAssertNotNil(firstSeason.id, "Must have a id")
                XCTAssertNotNil(firstSeason.type, "Must have a type")
                
                if let seasonAttrs = firstSeason.attributes {
                    XCTAssertNotNil(seasonAttrs.isCurrentSeason, "Must be a Bool")
                    XCTAssertNotNil(seasonAttrs.isOffseason, "Must be a Bool")
                }
                case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    func testGetPlayerData() {
        
        let playerName = "Netenho"
        self.interactor.getPlayersData(with: playerName) { (result) in
            switch result {
            case .success(let player):
                let firstPlayerFound = player.first!
                XCTAssertNotNil(firstPlayerFound.id, "Must have a id")
                XCTAssertNotNil(firstPlayerFound.attributes, "Must have a attrs")
                XCTAssertNotNil(firstPlayerFound.relationships, "Must have a relationships")
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
    }
}
