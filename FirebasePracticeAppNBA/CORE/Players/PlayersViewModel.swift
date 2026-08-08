//
//  PlayersViewModel.swift
//  FirebasePracticeAppNBA
//
//  Created by Antonio Gargiulo on 8/1/26.
//

import Foundation


import Foundation

@MainActor
final class PlayersViewModel: ObservableObject {
    
    @Published private(set) var players: [PlayerModel] = []
    
    private var lastDocument: DocumentSnapshotContainer? = nil
    
//    func getPlayersAndUploadToFB() {
//        Task {
//            do {
//                try await PlayerManager.shared.clearPlayersCollection()
//                PlayerManager.shared.downloadPlayersAndUploadToFirebase()
//            } catch {
//                print("Failed to clear players collection: \(error)")
//            }
//        }
//    }
    
    func getPlayers() {
        Task {
            let (newPlayers, lastDocument) = try await PlayerManager.shared.getAllPlayersPagination(count: 10, lastDocument: self.lastDocument)
            self.players.append(contentsOf: newPlayers)
            if let lastDocument {
                self.lastDocument = lastDocument
            }
        }
    }
}
