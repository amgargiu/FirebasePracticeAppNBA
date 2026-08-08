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
    
    // To fetch array of all players in memeory from FB
    func getAllPlayers()async throws -> [PlayerModel] {
        var query : Query = getAllPlayersQuery()
        
        // The fetch after we identify the query above
        
        return try await query
            .getDocuments2(as: PlayerModel.self)
    }
    
    // MARK: - Clear Collection
    
    // Fetches every document in the collection, then deletes them one at a
    // time. Reference this before re-uploading a fresh JSON so old players
    // don't linger alongside the new set.
    func clearPlayersCollection() async throws {
        let snapshot = try await playersCollection.getDocuments()
        for document in snapshot.documents {
            try await document.reference.delete()
        }
    }
    
    // MARK: - Fetch Specific Players by ID
    // Used this for the MyPicksViewModel - don't need to get all players if just looking at MyPicksView
    
        private func getPlayersQuery(ids: [String]) -> Query {
            playersCollection.whereField(FieldPath.documentID(), in: ids)
        }
        
        // Firestore's `in` query operator only accepts up to 30 values per query —
        // any more than that and the query throws instead of just fetching the
        // first 30. Rather than let that surface as a confusing failure once
        // someone's picks history grows past 30 unique players, this chunks the
        // requested ids into batches of 30 and runs one query per batch, merging
        // the results back into a single array.
        func getPlayers(ids: [Int]) async throws -> [PlayerModel] {
            guard !ids.isEmpty else { return [] }
            
            let stringIds = ids.map { $0.description }
            var allPlayers: [PlayerModel] = []
            
            for chunk in stringIds.chunked(into: 30) {
                let players = try await getPlayersQuery(ids: chunk).getDocuments2(as: PlayerModel.self)
                allPlayers.append(contentsOf: players)
            }
            
            return allPlayers
        }
    
    
//     MARK: - Download JSON + Upload to Firestore
    
    func downloadPlayersAndUploadToFirebase() {
        // April 15th 2026 - all teams played - i thin - aprile 12th commit
        // https://raw.githubusercontent.com/amgargiu/DraftKingsPick6_Practice/908d8ce4e161f32f9760ca814a7704ed2da39085/players.json

        guard let url = URL(string: "https://raw.githubusercontent.com/amgargiu/DraftKingsPick6_Practice/908d8ce4e161f32f9760ca814a7704ed2da39085/players.json") else {
            return
        }

        // use async await url sessions
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)

                // Note: unlike ProductArray, the JSON here is a top-level array,
                // so we decode straight into [PlayerModel] rather than a wrapper struct.
                let players = try JSONDecoder().decode([PlayerModel].self, from: data)

                for player in players {
                    try? await PlayerManager.shared.uploadPlayer(player: player)
                }

                print("Success")
                print(players.count)
            } catch {
                print(error)
            }
        }
    }
}

    
    
    
    
