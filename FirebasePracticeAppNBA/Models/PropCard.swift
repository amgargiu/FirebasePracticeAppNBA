//
//  PropCard.swift
//  FirebasePracticeAppNBA
//
//  Created by Antonio Gargiulo on 8/1/26.
//

import Foundation


enum CardType: String, Codable {
    case singlePlayerProp
    case pvpProp
}


struct PropCard: Identifiable {
    
    let id: String
    let cardType: CardType
    let stat: StatType
    
    // Single Player Prop fields (nil when cardType == .pvpProp)
    let player: PlayerModel?
    let line: Double?
    
    // PVP Prop fields (nil when cardType == .singlePlayerProp)
    let playerOne: PlayerModel?
    let playerTwo: PlayerModel?
    
    // MARK: - Factory Initializers
    
    static func singlePlayerProp(
        id: String = UUID().uuidString,
        stat: StatType,
        player: PlayerModel,
        line: Double
    ) -> PropCard {
        PropCard(
            id: id,
            cardType: .singlePlayerProp,
            stat: stat,
            player: player,
            line: line,
            playerOne: nil,
            playerTwo: nil
        )
    }
    
    static func pvpProp(
        id: String = UUID().uuidString,
        stat: StatType,
        playerOne: PlayerModel,
        playerTwo: PlayerModel
    ) -> PropCard {
        PropCard(
            id: id,
            cardType: .pvpProp,
            stat: stat,
            player: nil,
            line: nil,
            playerOne: playerOne,
            playerTwo: playerTwo
        )
    }
}


enum StatType: String, Codable, CaseIterable {
    case min = "MIN"
    case fgm = "FGM"
    case fga = "FGA"
    case ftm = "FTM"
    case fta = "FTA"
    case threePM = "3PM"
    case reb = "REB"
    case ast = "AST"
    case stl = "STL"
    case blk = "BLK"
    case to = "TO"
    case pts = "PTS"
    
    var displayName: String {
        switch self {
        case .min: return "Minutes"
        case .fgm: return "Field Goals Made"
        case .fga: return "Field Goals Attempted"
        case .ftm: return "Free Throws Made"
        case .fta: return "Free Throws Attempted"
        case .threePM: return "3PM"
        case .reb: return "Rebounds"
        case .ast: return "Assists"
        case .stl: return "Steals"
        case .blk: return "Blocks"
        case .to: return "Turnovers"
        case .pts: return "Points"
        }
    }
}



/// Mock PropCard instances for SwiftUI previews only.
/// Declared as `static let`, not computed `var` — the factory methods default
/// to a fresh UUID each call, so a computed property would generate a
/// different id every time it's accessed, breaking anything that matches
/// against card.id (like decisions lookups) across multiple preview uses.
extension PropCard {
    
    static let mockSingle: PropCard = .singlePlayerProp(
        stat: .reb,
        player: PlayerModel.mock(
            id: 1,
            name: "Victor Wembanyama",
            team: "SAS",
            opp: "MIN",
            pts: 24.3,
            image: "https://cdn.nba.com/headshots/nba/latest/1040x760/1641705.png",
            teamImage: "https://a.espncdn.com/i/teamlogos/nba/500/sa.png"
        ),
        line: 10.5
    )
    
    static let mockPVP: PropCard = .pvpProp(
        stat: .pts,
        playerOne: PlayerModel.mock(
            id: 1,
            name: "Cade Cunningham",
            team: "DET",
            opp: "CLE",
            pts: 24.5,
            image: "https://cdn.nba.com/headshots/nba/latest/1040x760/1630595.png",
            teamImage: "https://a.espncdn.com/i/teamlogos/nba/500/det.png"
        ),
        playerTwo: PlayerModel.mock(
            id: 2,
            name: "Donovan Mitchell",
            team: "CLE",
            opp: "@DET",
            pts: 25.5,
            image: "https://cdn.nba.com/headshots/nba/latest/1040x760/1628378.png",
            teamImage: "https://a.espncdn.com/i/teamlogos/nba/500/cle.png"
        )
    )
}
