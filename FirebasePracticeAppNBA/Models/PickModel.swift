//
//  PickModel.swift
//  FirebasePracticeAppNBA
//
//  Created by Antonio Gargiulo on 8/1/26.
//

import Foundation


import Foundation

// MARK: - Supporting Enums


enum OverUnder: String, Codable {
    case over
    case under
}


// MARK: - PickModel

struct PickModel: Identifiable, Codable, Hashable {
    
    let id: String
    let userId: String
    let cardType: CardType
    let stat: StatType
    
    // Single Player Prop fields (nil when cardType == .pvpProp)
    let playerId: Int?
    let line: Double?
    let overUnder: OverUnder?
    
    // PVP Prop fields (nil when cardType == .singlePlayerProp)
    let playerOneId: Int?
    let playerTwoId: Int?
    let selectedPlayerId: Int?
    
    // MARK: - Factory Initializers
    // Use these instead of the memberwise init directly, so you can't
    // accidentally set single-player fields on a PVP pick or vice versa.
    
    /*
     Factory methods, not a public memberwise init. Since Swift auto-synthesizes a memberwise init for structs, technically someone could still call PickModel(id:cardType:stat:playerId:line:overUnder:playerOneId:playerTwoId:selectedPlayerId:) directly and set garbage combinations. If you want to fully lock that down, I'd need to make the memberwise init private — happy to add that if you want stricter guarantees.
     */
    
    static func singlePlayerProp(
        id: String = UUID().uuidString,
        userId: String,
        stat: StatType,
        playerId: Int,
        line: Double,
        overUnder: OverUnder
    ) -> PickModel {
        PickModel(
            id: id,
            userId: userId,
            cardType: .singlePlayerProp,
            stat: stat,
            playerId: playerId,
            line: line,
            overUnder: overUnder,
            playerOneId: nil,
            playerTwoId: nil,
            selectedPlayerId: nil
        )
    }
    
    static func pvpProp(
        id: String = UUID().uuidString,
        userId: String,
        stat: StatType,
        playerOneId: Int,
        playerTwoId: Int,
        selectedPlayerId: Int
    ) -> PickModel {
        PickModel(
            id: id,
            userId: userId,
            cardType: .pvpProp,
            stat: stat,
            playerId: nil,
            line: nil,
            overUnder: nil,
            playerOneId: playerOneId,
            playerTwoId: playerTwoId,
            selectedPlayerId: selectedPlayerId
        )
    }
}
