import Foundation

public protocol HTTPClient {
    var baseURL: URL { get }
    var manager: SessionManager { get }
}
