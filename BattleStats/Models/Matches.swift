import Foundation
struct MatchesData: Codable {
    let data: [Match]?
}

struct Match: Codable {
    
    struct Attributes: Codable {
        let iCustomMatch:Bool
        let createdAt: String
        let duration: Int
        let gameMode: String
        let shardId: String
        let mapName: String
    }
    
    let type:String
    let id:String
    let attributes: Attributes?
}
