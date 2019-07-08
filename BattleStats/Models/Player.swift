import Foundation

struct PlayersData: Codable {
    let data: [Player]
}

struct Player: Codable {
    
    struct Attributes: Codable {
        let createdAt: String
        let updatedAt: String
        let patchVersion: String
        let name: String
        let titleId: String
        let shardId: String
    }
    
    struct Relationships: Codable {
        let matches: MatchesData?
    }
    
    let type: String
    let id: String
    let attributes: Attributes
    let relationships: Relationships
}
