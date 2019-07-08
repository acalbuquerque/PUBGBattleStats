import Foundation

enum RequestErrors: Error {
    case waitingForConnectivity
    case invalidURL
    case missingResponse
}
