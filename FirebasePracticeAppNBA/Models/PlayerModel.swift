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
