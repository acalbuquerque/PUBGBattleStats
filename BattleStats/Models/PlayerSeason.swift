import Foundation

struct PlayerSeasonData: Codable {
    let data: PlayerSeason
}

struct PlayerSeason: Codable {
    
    struct Attributes: Codable {
        let gameModeStats: GameModeStats
    }
    
    struct Relationships: Codable {
        
        let matchesSolo: MatchesData?
        let matchesDuo: MatchesData?
        let matchesSquad: MatchesData?
        let matchesSoloFPP: MatchesData?
        let matchesDuoFPP: MatchesData?
        let matchesSquadFPP: MatchesData?
    }
    
    let type: String
    let attributes: Attributes
    let relationships: Relationships
}

struct GameModeStats: Codable {
    
    let duo: GameAttr
    let duoFpp: GameAttr
    let solo: GameAttr
    let soloFpp: GameAttr
    let squad: GameAttr
    let squadFpp: GameAttr
    
    enum CodingKeys: String, CodingKey {
        case duo
        case duoFpp = "duo-fpp"
        case solo
        case soloFpp = "solo-fpp"
        case squad
        case squadFpp = "squad-fpp"
    }
}

struct GameAttr: Codable {
    let assists: Int
    let boosts: Int
    let dBNOs: Int
    let dailyKills: Int
    let damageDealt: Float
    let days: Int
    let headshotKills: Int
    let heals: Int
    let killPoints: Float
    let kills: Int
    let longestKill: Float
    let longestTimeSurvived: Float
    let losses: Int
    let maxKillStreaks: Int
    let mostSurvivalTime: Float
    let revives: Int
    let rideDistance: Float
    let roadKills: Int
    let roundMostKills: Int
    let roundsPlayed: Int
    let suicides: Int
    let teamKills: Int
    let timeSurvived: Float
    let top10s: Int
    let vehicleDestroys: Int
    let walkDistance: Float
    let weaponsAcquired: Float
    let weeklyKills: Int
    let winPoints: Float
    let wins: Int
}
