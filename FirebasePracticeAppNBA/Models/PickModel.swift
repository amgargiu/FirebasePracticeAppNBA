//
//  PickModel.swift
//  FirebasePracticeAppNBA
//
//  Created by Antonio Gargiulo on 8/1/26.
//

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
    
    // Set to the client's current time at creation, same pattern as DBUser's
    // init(auth:). Kept Optional so older documents that predate this field
    // can still decode cleanly with a nil rather than failing outright.
    let dateCreated: Date?
    
    // MARK: - Coding Keys
    // Explicit even though every key currently matches the property name 1:1 —
    // this is the single place to change if a Firestore field name ever needs
    // to diverge from the Swift property name (same pattern as PlayerModel's "3PM").
    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case cardType
        case stat
        case playerId
        case line
        case overUnder
        case playerOneId
        case playerTwoId
        case selectedPlayerId
        case dateCreated
    }
    
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
            selectedPlayerId: nil,
            dateCreated: Date()
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
            selectedPlayerId: selectedPlayerId,
            dateCreated: Date()
        )
    }
}
