import Foundation

enum Result<U> {
    case success(U)
    case failure(Error)
}
