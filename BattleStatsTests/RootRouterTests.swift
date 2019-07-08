import XCTest
@testable import BattleStats

class RootRouterTests: XCTestCase {
    
    let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    var router: RootRouter!

    func testStart() {
        let rootNavigationController = RootNavigationController()
        router = RootRouter(window: window, viewController: rootNavigationController)
        router.start()
        
        let viewController = rootNavigationController.viewControllers.first
        XCTAssertTrue(viewController!.isKind(of: HomeTabBarController.self))
    }

}
