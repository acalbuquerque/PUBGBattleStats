import Foundation

protocol EnvironmentInterface {
    var processInfo: ProcessInfoInterface { get }
    var bundle: Bundle { get }
    var userDefaults: UserDefaults { get }
    var fileManager: FileManager { get }
    var current: Environment.EnvType { get }
    var enableRequestLogs: Bool { get }
    var testAPIBaseURL: URL { get }
    
    init(bundle: Bundle, userDefaults: UserDefaults, fileManager: FileManager, processInfo: ProcessInfoInterface)
}

public protocol ProcessInfoInterface: class {
    var arguments: [String] { get }
    var environment: [String : String] { get }
}

extension ProcessInfo: ProcessInfoInterface {}

public struct Environment: EnvironmentInterface {
    
    public enum EnvType: String {
        case staging
        case production
        case tests
    }
    
    public let processInfo: ProcessInfoInterface
    public var bundle: Bundle
    public let userDefaults: UserDefaults
    public let fileManager: FileManager
    
    public var current: EnvType {
        
        var current: EnvType
        
        if isRunningAnyTests() {
            current = .tests
        } else {
            if let environmentString = bundle.object(forInfoDictionaryKey: "AppEnvironment") as? String,
                let environment = EnvType(rawValue: environmentString) {
                current = environment
            } else {
                current = .production
            }
        }
        
        return current
    }
    
    public var enableRequestLogs: Bool {
        let enableRequestLogs: String = processInfo.environment["ENABLE_REQUEST_LOGS"] ?? "NO"
        return enableRequestLogs == "YES" ? true : false
    }
    
    public init(bundle: Bundle = Bundle.main,
                userDefaults: UserDefaults = UserDefaults.standard,
                fileManager: FileManager = FileManager.default,
                processInfo: ProcessInfoInterface = ProcessInfo.processInfo) {
        
        self.bundle = bundle
        self.userDefaults = userDefaults
        self.fileManager = fileManager
        self.processInfo = processInfo
    }
}

extension Environment: Equatable {
    public static func ==(lhs: Environment, rhs: Environment) -> Bool {
        return lhs.current == rhs.current
    }
}

extension Environment {
    
    func isRunningAnyTests(classString: String = "XCTestCase") -> Bool {
        return isRunningUnitTests(classString: classString) || isRunningUITests
    }
    
    func isRunningUnitTests(classString: String = "XCTestCase") -> Bool {
        return NSClassFromString(classString) != nil
    }
    
    public static let UITestsEnvironmentVariableKey: String = "RunningUITests"
    
    var isRunningUITests: Bool {
        let isRunningUITests = processInfo.arguments.contains(Environment.UITestsEnvironmentVariableKey)
        return isRunningUITests
    }
    
    var testAPIBaseURL: URL {
        return Constants.TestServerURL
    }
}

public struct Platform {
    
    public static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
}
