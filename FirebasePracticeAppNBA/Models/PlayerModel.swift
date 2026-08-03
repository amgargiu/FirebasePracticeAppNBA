//
//  PlayerModel.swift
//  DraftKingsPick6_Practice
//
//  Created by Antonio Gargiulo on 3/8/26.
//

import Foundation


struct PlayerModel: Identifiable, Codable, Hashable {
    
    let id: Int?
    
    let player, image, team, teamImage, position, opp, time: String?
    
    let MIN, FGM, FGA, FTM, FTA, threePM, REB, AST, STL, BLK, TO, PTS: Double?
    
    let last5Min, last5FGM, last5FGA, last5FTM, last5FTA, last5ThreePM, last5REB, last5AST, last5STL, last5BLK, last5TO, last5PTS: Double?
    
    let pctRostered: Double?
    let fantasyPtsTotal: Int?
    let fantasyPtsAvg: Double?
    let injuryStatus: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case player, image, team, teamImage, position, opp, time
        case MIN, FGM, FGA, FTM, FTA, REB, AST, STL, BLK, TO, PTS
        case pctRostered, fantasyPtsTotal, fantasyPtsAvg, injuryStatus
        case threePM = "3PM"
        case last5Min = "last5_MIN"
        case last5FGM = "last5_FGM"
        case last5FGA = "last5_FGA"
        case last5FTM = "last5_FTM"
        case last5FTA = "last5_FTA"
        case last5ThreePM = "last5_3PM"
        case last5REB = "last5_REB"
        case last5AST = "last5_AST"
        case last5STL = "last5_STL"
        case last5BLK = "last5_BLK"
        case last5TO = "last5_TO"
        case last5PTS = "last5_PTS"
    }
}


extension PlayerModel {
    
    // MARK: - String Unwrapping
    var displayName: String { player ?? "Unknown Player" }
    var displayTeam: String { team ?? "FA" }
    var displayPosition: String { position ?? "N/A" }
    var displayOpp: String { opp ?? "---" }
    var displayTime: String { time ?? "--:--" }
    var displayInjury: String { injuryStatus ?? "Healthy" }
    
    var abbrevName: String {
        guard let player else { return "Unknown Player" }
        let splitName = player.split(separator: " ")
        return "\(splitName[0].prefix(1).uppercased()). \(splitName[1])."
    }
    
    
    
    // MARK: - Stats (Double to String Formatting) - Unwrapping
    var ptsString: String { formatDouble(PTS) }
    var astString: String { formatDouble(AST) }
    var rebString: String { formatDouble(REB) }
    var stlString: String { formatDouble(STL) }
    var blkString: String { formatDouble(BLK) }
    var toString: String { formatDouble(TO) }
    var fgmString: String { formatDouble(FGM) }
    var fgaString: String { formatDouble(FGA) }
    var ftmString: String { formatDouble(FTM) }
    var ftaString: String { formatDouble(FTA) }
    var minString: String { formatDouble(MIN) }
    var threePMString: String { formatDouble(threePM) }
    
    // MARK: - Advanced Stats
    var rosteredString: String {
        if let pct = pctRostered {
            return String(format: "%.1f%%", pct * 100)
        }
        return "0%"
    }
    
    var fantasyTotal: String {
        if let total = fantasyPtsTotal {
            return "\(total)"
        }
        return "0"
    }
    
    var fantasyAvg: String { formatDouble(fantasyPtsAvg) }

    // MARK: - Helper Private Formatter
    private func formatDouble(_ value: Double?) -> String {
        // 1. Handle the nil case
        guard let value = value else { return "0.5" }
        // 2. Do the math
        let result = floor(value) + 0.5
        // 3. Force it into a String with 1 decimal place ("%.1f")
        return String(format: "%.1f", result)
    }
}


extension PlayerModel {
    
    /// Returns this player's season-average value for a given StatType,
    /// so card-generation logic can work generically off StatType
    /// instead of switching on individual PlayerModel properties.
    func statValue(for stat: StatType) -> Double? {
        switch stat {
        case .min: return MIN
        case .fgm: return FGM
        case .fga: return FGA
        case .ftm: return FTM
        case .fta: return FTA
        case .threePM: return threePM
        case .reb: return REB
        case .ast: return AST
        case .stl: return STL
        case .blk: return BLK
        case .to: return TO
        case .pts: return PTS
            
        }
    }
}


// MARK: Dev Preview Mock


import Foundation

/// Mock data helpers for SwiftUI previews only.
/// Not intended for use in production code paths.
extension PlayerModel {
    
    static func mock(
        id: Int,
        name: String,
        team: String? = nil,
        opp: String? = nil,
        pts: Double = 20.4,
        image: String? = nil,
        teamImage: String? = nil,
        position: String? = nil
    ) -> PlayerModel {
        PlayerModel(
            id: id,
            player: name,
            image: image,
            team: team,
            teamImage: teamImage,
            position: position,
            opp: opp,
            time: nil,
            MIN: nil,
            FGM: nil,
            FGA: nil,
            FTM: nil,
            FTA: nil,
            threePM: nil,
            REB: nil,
            AST: nil,
            STL: nil,
            BLK: nil,
            TO: nil,
            PTS: pts,
            last5Min: nil,
            last5FGM: nil,
            last5FGA: nil,
            last5FTM: nil,
            last5FTA: nil,
            last5ThreePM: nil,
            last5REB: nil,
            last5AST: nil,
            last5STL: nil,
            last5BLK: nil,
            last5TO: nil,
            last5PTS: nil,
            pctRostered: nil,
            fantasyPtsTotal: nil,
            fantasyPtsAvg: nil,
            injuryStatus: nil
        )
    }
}


// MARK: Team Colors

import SwiftUI

extension Color {
    /// Convenience initializer for defining team colors as hex strings below.
    init(hex: String) {
        let scanner = Scanner(string: hex.trimmingCharacters(in: .whitespacesAndNewlines))
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = Double((rgbValue & 0xFF0000) >> 16) / 255
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255
        let b = Double(rgbValue & 0x0000FF) / 255
        
        self.init(red: r, green: g, blue: b)
    }
}

extension PlayerModel {
    
    /// Approximate primary color from each team's away jersey, for card/UI theming.
    /// Falls back to a neutral gray if the team abbreviation isn't recognized.
    var teamColor: Color {
        guard let team else { return .gray }
        
        switch team.uppercased() {
        case "ATL": return Color(hex: "E13A3E") // Hawks red
        case "BOS": return Color(hex: "007A33") // Celtics green
        case "BKN": return Color(hex: "000000") // Nets black
        case "CHA": return Color(hex: "00788C") // Hornets teal
        case "CHI": return Color(hex: "CE1141") // Bulls red
        case "CLE": return Color(hex: "6F263D") // Cavaliers maroon
        case "DAL": return Color(hex: "B0C4DE") // Mavericks light blue/gray
        case "DEN": return Color(hex: "0E2240") // Nuggets navy
        case "DET": return Color(hex: "1D42BA") // Pistons blue
        case "GSW": return Color(hex: "1D428A") // Warriors blue
        case "HOU": return Color(hex: "CE1141") // Rockets red
        case "IND": return Color(hex: "002D62") // Pacers navy
        case "LAC": return Color(hex: "C8102E") // Clippers red
        case "LAL": return Color(hex: "FDB927") // Lakers yellow
        case "MEM": return Color(hex: "5D76A9") // Grizzlies blue
        case "MIA": return Color(hex: "98002E") // Heat red
        case "MIL": return Color(hex: "00471B") // Bucks green
        case "MIN": return Color(hex: "0C2340") // Timberwolves navy
        case "NOP": return Color(hex: "002B5C") // Pelicans navy
        case "NYK": return Color(hex: "006BB6") // Knicks blue
        case "OKC": return Color(hex: "007AC1") // Thunder blue
        case "ORL": return Color(hex: "0077C0") // Magic blue
        case "PHI": return Color(hex: "ED174C") // 76ers red
        case "PHX": return Color(hex: "E56020") // Suns orange
        case "POR": return Color(hex: "E03A3E") // Trail Blazers red
        case "SAC": return Color(hex: "5A2D81") // Kings purple
        case "SAS": return Color(hex: "000000") // Spurs black
        case "TOR": return Color(hex: "CE1141") // Raptors red
        case "UTA": return Color(hex: "5C2D91") // Jazz purple
        case "WAS": return Color(hex: "002B5C") // Wizards navy
        default: return .gray
        }
    }
}
