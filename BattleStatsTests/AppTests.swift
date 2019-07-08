import XCTest
@testable import BattleStats

class AppTests: XCTestCase {
    
    var window: UIWindow!

    override func setUp() {
        super.setUp()
        window = UIWindow(frame: CGRect.zero)
        window.restorationIdentifier = "test-window"
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testBuildRootRouter() {
        self.measure {
            let buildExpectation = expectation(description: "expected to call build()")
            let rootBuilder = MockRootBuilder()
            rootBuilder.buildExpectation = buildExpectation
            
            _ = App(window: window,
                    rootBuilder: rootBuilder,
                    environment: Environment())
            
            wait(for: [buildExpectation], timeout: 2)
        }
    }
    
    func testRootRouterStart() {
        self.measure {
            let rootBuilder = MockRootBuilder()
            let startExpectation = expectation(description: "expect to call start()")
            rootBuilder.startFromWindowExpectation = startExpectation
            
            let app = App(window: window,
                          rootBuilder: rootBuilder,
                          environment: Environment())
            
            app.start()
            
            wait(for: [startExpectation], timeout: 2)
        }
    }
    
    func testWindowLayerSpeedDuringUITests() {
        self.measure {
            let rootBuilder = MockRootBuilder()
            let processInfo = MockProcessInfo()
            processInfo.arguments += [Environment.UITestsEnvironmentVariableKey]
            
            let app = App(window: window,
                          rootBuilder: rootBuilder,
                          environment: Environment(processInfo: processInfo))
            
            app.start()
            
            XCTAssertEqual(app.application.keyWindow!.layer.speed, 100, accuracy: 0.001)
        }
    }
}

class MockRootBuilder: RootBuilderInterface {

    var buildExpectation: XCTestExpectation?
    var startFromWindowExpectation: XCTestExpectation?
    
    func build(withWindow window: UIWindow) -> RootRouterInterface {
        
        buildExpectation?.fulfill()
        XCTAssertEqual(window.restorationIdentifier, "test-window")
        
        let rootRouter = MockRootRouter()
        rootRouter.startFromWindowExpectation = startFromWindowExpectation
        
        return rootRouter
    }
}

class MockRootRouter: RootRouterInterface {
    
    var startFromWindowExpectation: XCTestExpectation?
    
    func start() {
        startFromWindowExpectation?.fulfill()
    }
}

class MockProcessInfo: ProcessInfoInterface {
    var arguments: [String] = []
    var environment: [String : String] = [:]
}

