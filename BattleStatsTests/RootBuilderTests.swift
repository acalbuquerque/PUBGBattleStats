import XCTest
@testable import BattleStats

class RootBuilderTests: XCTestCase {

    let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

    func testBuild() {
        let rootBuilder = RootBuilder()
        let vcInterface = rootBuilder.build(withWindow: window)
        XCTAssertNotNil(vcInterface)
    }
}
