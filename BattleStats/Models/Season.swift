import Foundation

struct SeasonsData: Codable {
    let data: [Season]
}

struct Season: Codable{
    
    struct attributes: Codable {
        let isCurrentSeason:Bool
        let isOffseason: Bool
    }
    
    let type : String
    let id : String
    let attributes: attributes?
}
