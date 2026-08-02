//
//  CardGenerator.swift
//  FirebasePracticeAppNBA
//
//  Created by Antonio Gargiulo on 8/1/26.
//

import Foundation

final class CardGenerator {
    
    // Curated subset — only the "interesting" stats for prop cards
    private static let curatedStats: [StatType] = [.pts, .reb, .ast, .threePM, .stl, .blk]
    
    // Minimum season average a player needs in a stat before it's eligible for a card
    private static let statThresholds: [StatType: Double] = [
        .pts: 14,
        .reb: 6,
        .ast: 4,
        .threePM: 2,
        .stl: 1,
        .blk: 1
    ]
    
    // MARK: - Public Entry Point
    
    static func generateCards(from players: [PlayerModel], count: Int) -> [PropCard] {
        var cards: [PropCard] = []
        var usedSignatures: Set<String> = []
        
        var attempts = 0
        let maxAttempts = count * 20 // higher ceiling now that generation is more selective
        
        while cards.count < count && attempts < maxAttempts {
            attempts += 1
            
            let cardType: CardType = Bool.random() ? .singlePlayerProp : .pvpProp
            
            let newCard: PropCard?
            switch cardType {
            case .singlePlayerProp:
                newCard = generateSinglePlayerCard(from: players)
            case .pvpProp:
                newCard = generatePVPCard(from: players)
            }
            
            guard let card = newCard else { continue }
            
            let sig = signature(for: card)
            guard !usedSignatures.contains(sig) else { continue }
            
            usedSignatures.insert(sig)
            cards.append(card)
        }
        
        return cards
    }
    
    // MARK: - Single Player Prop
    
    private static func generateSinglePlayerCard(from players: [PlayerModel]) -> PropCard? {
        guard let player = players.randomElement() else { return nil }
        
        let eligibleStats = eligibleStats(for: player)
        guard let stat = eligibleStats.randomElement(),
              let value = player.statValue(for: stat) else { return nil }
        
        // Turns any average into a valid, tie-proof prop line (e.g. 20.4 -> 20.5)
        let line = floor(value) + 0.5
        
        return .singlePlayerProp(stat: stat, player: player, line: line)
    }
    
    // MARK: - PVP Prop
    
    private static func generatePVPCard(from players: [PlayerModel]) -> PropCard? {
        guard let stat = curatedStats.randomElement() else { return nil }
        
        // Only consider players who actually clear the minimum threshold for this stat
        let eligiblePlayers = players.filter { eligibleStats(for: $0).contains(stat) }
        
        let sortedByStat = eligiblePlayers
            .compactMap { player -> (player: PlayerModel, value: Double)? in
                guard let value = player.statValue(for: stat) else { return nil }
                return (player, value)
            }
            .sorted { $0.value > $1.value }
        
        guard sortedByStat.count >= 2 else { return nil }
        
        // Walk adjacent pairs (closest stat values) and take the first pair
        // that isn't from the same game — covers both teammates and opponents.
        for i in 0..<(sortedByStat.count - 1) {
            let playerOne = sortedByStat[i].player
            let playerTwo = sortedByStat[i + 1].player
            
            if !isSameGame(playerOne, playerTwo) {
                return .pvpProp(stat: stat, playerOne: playerOne, playerTwo: playerTwo)
            }
        }
        
        return nil
    }
    
    // MARK: - Relevance Filtering
    
    /// Returns the stats where this player clears the minimum season-average
    /// threshold — this is what keeps a low-usage player from getting a
    /// degenerate prop card in a stat they barely produce.
    private static func eligibleStats(for player: PlayerModel) -> [StatType] {
        curatedStats.filter { stat in
            guard let value = player.statValue(for: stat),
                  let threshold = statThresholds[stat] else { return false }
            return value >= threshold
        }
    }
    
    // MARK: - Game Matching
    
    /// True if both players are in the same matchup, using team + opponent
    /// (stripping "@" for away games) — catches both teammates and opponents.
    private static func isSameGame(_ playerA: PlayerModel, _ playerB: PlayerModel) -> Bool {
        guard let teamA = playerA.team, let oppA = playerA.opp,
              let teamB = playerB.team, let oppB = playerB.opp else { return false }
        
        let keyA = [teamA, oppA.replacingOccurrences(of: "@", with: "")].sorted()
        let keyB = [teamB, oppB.replacingOccurrences(of: "@", with: "")].sorted()
        
        return keyA == keyB
    }
    
    // MARK: - Duplicate Prevention
    
    /// A unique signature per generated card, used to prevent the same
    /// player+stat (or player-pair+stat) from appearing twice in one batch.
    private static func signature(for card: PropCard) -> String {
        switch card.cardType {
        case .singlePlayerProp:
            guard let player = card.player, let id = player.id else { return UUID().uuidString }
            return "single-\(id)-\(card.stat.rawValue)"
        case .pvpProp:
            guard let playerOne = card.playerOne, let idOne = playerOne.id,
                  let playerTwo = card.playerTwo, let idTwo = playerTwo.id else { return UUID().uuidString }
            let sortedIDs = [idOne, idTwo].sorted()
            return "pvp-\(sortedIDs)-\(card.stat.rawValue)"
        }
    }
}
