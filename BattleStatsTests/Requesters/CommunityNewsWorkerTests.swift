import XCTest
@testable import BattleStats

class CommunityNewsWorkerTests: XCTestCase {
    
    lazy var mockedNews: [News] = {
        let json = JSONLoader().loadJSON(filename: "News")!
        let news = try! JSONDecoder().decode(Array<News>.self, from: json)
        return news
    }()
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testMakeRequest() {
        let newsWorker = CommunityNewsWorker()
        let request = try! newsWorker.makeRequest()
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.url!, URL(string: "http://127.0.0.1:8080/news")!)
        XCTAssertEqual(request.allHTTPHeaderFields?["Authorization"], nil) // this endpoint does not have a auth token
    }
    
    func testParseModel() {
        let json = JSONLoader().loadJSON(filename: "News")!
        do {
            let mockedNews = try JSONDecoder().decode([News].self, from: json)
            XCTAssertNotNil(mockedNews, "News can not be nil")
            
            for item in mockedNews {
                XCTAssertNotNil(item.title)
                XCTAssertNotNil(item.imageURL)
                XCTAssertNotNil(item.newsURL)
                XCTAssertNotNil(item.type)
            }
        } catch let error as DecodingError {
            XCTFail(error.errorDescription ?? "DecodingError")
        } catch let error {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testGetNews(){
        let interactor = CommunityNewsInteractor()
        interactor.getNews { (result) in
            switch result {
            case .success(let news):
                XCTAssertNotNil(news, "News can not be nil")
                
                let firstNews = news.first! // if the first has error, this is the base case
                XCTAssertNotNil(firstNews.title, "Must have a title")
                XCTAssertNotNil(firstNews.imageURL, "Must have a image")
                XCTAssertNotNil(firstNews.newsURL, "Must have a url")
                XCTAssertNotNil(firstNews.type, "Must have a type")
                
                XCTAssertEqual(firstNews, self.mockedNews.first!)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
    }
}
