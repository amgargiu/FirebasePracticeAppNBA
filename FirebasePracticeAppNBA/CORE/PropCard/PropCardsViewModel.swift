//
//  PropCardsViewModel.swift
//  FirebasePracticeAppNBA
//
//  Created by Antonio Gargiulo on 8/1/26.
//

import Foundation

@MainActor
final class PropCardsViewModel: ObservableObject {
    
    @Published private(set) var propCards: [PropCard] = []
    // Cached, not published — the view never reads this directly.
    // Kept around so cards can be regenerated without a new Firestore fetch.
    private var players: [PlayerModel] = []
    
    func loadPropCards(count: Int = 7) {
        Task {
            do {
                let fetchedPlayers = try await PlayerManager.shared.getAllPlayers()
                self.players = fetchedPlayers
                self.propCards = CardGenerator.generateCards(from: fetchedPlayers, count: count)
            } catch {
                print("Error fetching players: \(error)")
            }
        }
    }
    
    func regenerateCards(count: Int = 7) {
        guard !players.isEmpty else { return }
        propCards = CardGenerator.generateCards(from: players, count: count)
    }
}
