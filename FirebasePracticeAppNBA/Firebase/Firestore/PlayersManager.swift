//
//  PlayersManager.swift
//  FirebasePracticeAppNBA
//
//  Created by Antonio Gargiulo on 8/1/26.
//

import Foundation
import FirebaseFirestore

final class PlayerManager {
    
    static let shared = PlayerManager()
    private init() { }
    
    private let playersCollection = Firestore.firestore().collection("players")
    
    // get path to individual doc
    private func playerDocument(playerId: String) -> DocumentReference {
        playersCollection.document(playerId)
    }
    
    // mark as async since going to server
    func uploadPlayer(player: PlayerModel) async throws {
        guard let id = player.id else { return }
        try playerDocument(playerId: id.description).setData(from: player, merge: false)
    }
    
    // get 1 document - decode
    func getPlayer(playerId: String) async throws -> PlayerModel {
        try await playerDocument(playerId: playerId).getDocument(as: PlayerModel.self)
    }
    
    
    private func getAllPlayersQuery() -> Query {
        playersCollection
    }
    
    func getAllPlayersPagination(count: Int, lastDocument: DocumentSnapshotContainer?) async throws -> (products: [PlayerModel], lastDoc: DocumentSnapshotContainer?) {
        var query : Query = getAllPlayersQuery()
        
        // The fetch after we identify the query above
        
        return try await query
            .limit(to: count)
            .startOptional(afterDocument: lastDocument)
            .getDocumentsWithSnapshot(as: PlayerModel.self)
    }
    
    
    func getAllPlayers()async throws -> [PlayerModel] {
        var query : Query = getAllPlayersQuery()
        
        // The fetch after we identify the query above
        
        return try await query
            .getDocuments2(as: PlayerModel.self)
    }
}
    
    
    
    
    
    // MARK: - Download JSON + Upload to Firestore
    
//    func downloadPlayersAndUploadToFirebase() {
//        // https://raw.githubusercontent.com/amgargiu/DraftKingsPick6_Practice/32773f6e123da7dd620ebf57feee7389d477d383/players.json
//        
//        guard let url = URL(string: "https://raw.githubusercontent.com/amgargiu/DraftKingsPick6_Practice/32773f6e123da7dd620ebf57feee7389d477d383/players.json") else {
//            return
//        }
//        
//        // use async await url sessions
//        Task {
//            do {
//                let (data, _) = try await URLSession.shared.data(from: url)
//                
//                // Note: unlike ProductArray, the JSON here is a top-level array,
//                // so we decode straight into [PlayerModel] rather than a wrapper struct.
//                let players = try JSONDecoder().decode([PlayerModel].self, from: data)
//                
//                for player in players {
//                    try? await PlayerManager.shared.uploadPlayer(player: player)
//                }
//                
//                print("Success")
//                print(players.count)
//            } catch {
//                print(error)
//            }
//        }
//    }
//}
