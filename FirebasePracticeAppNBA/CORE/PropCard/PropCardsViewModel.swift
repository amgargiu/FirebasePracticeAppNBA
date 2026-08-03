//
//  PropCardsViewModel.swift
//  FirebasePracticeAppNBA
//
//  Created by Antonio Gargiulo on 8/1/26.
//

import Foundation

//@MainActor
//final class PropCardsViewModel: ObservableObject {
//    
//    @Published private(set) var propCards: [PropCard] = []
//    // Cached, not published — the view never reads this directly.
//    // Kept around so cards can be regenerated without a new Firestore fetch.
//    private var players: [PlayerModel] = []
//    
//    func loadPropCards(count: Int = 7) {
//        Task {
//            do {
//                let fetchedPlayers = try await PlayerManager.shared.getAllPlayers()
//                self.players = fetchedPlayers
//                self.propCards = CardGenerator.generateCards(from: fetchedPlayers, count: count)
//            } catch {
//                print("Error fetching players: \(error)")
//            }
//        }
//    }
//    
//    func regenerateCards(count: Int = 7) {
//        guard !players.isEmpty else { return }
//        propCards = CardGenerator.generateCards(from: players, count: count)
//    }
//}


import Foundation

@MainActor
final class PropCardsViewModel: ObservableObject {
    
    @Published private(set) var propCards: [PropCard] = []
    
    // The single source of truth for what's been decided, shared across the
    // swipe stack and the review screen — not duplicated into a separate
    // PickModel array, since PickModel is just this data resolved on demand.
    @Published var decisions: [String: CardDecision] = [:]
    
    // Cached, not published — the view never reads this directly.
    // Kept around so cards can be regenerated without a new Firestore fetch.
    private var players: [PlayerModel] = []
    
    func loadPropCards(count: Int = 10) {
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
    
    func regenerateCards(count: Int = 10) {
        guard !players.isEmpty else { return }
        propCards = CardGenerator.generateCards(from: players, count: count)
    }
    
    // MARK: - Review Screen Support
    
    /// Flips an already-decided card's choice — Over <-> Under for single player
    /// props, or Player One <-> Player Two for PVP props. Used by the review
    /// screen's inline tap-to-flip editing.
    func toggleDecision(for card: PropCard) {
        guard let current = decisions[card.id], current != .none else { return }
        decisions[card.id] = current == .up ? .down : .up
    }
    
    /// Resolves the current decisions into upload-ready PickModels. Pure aside
    /// from the auth check — safe to call repeatedly as the user keeps editing
    /// before actually confirming. Throws if nobody's signed in, since a
    /// PickModel can't exist without a userId to attach it to.
    func resolvePicks() throws -> [PickModel] {
        let authResult = try AuthManager.shared.getAuthenticatedUser()
        let userId = authResult.uid
        
        return propCards.compactMap { card -> PickModel? in
            guard let decision = decisions[card.id], decision != .none else { return nil }
            
            switch card.cardType {
            case .singlePlayerProp:
                guard let player = card.player, let playerID = player.id, let line = card.line else { return nil }
                return .singlePlayerProp(
                    userId: userId,
                    stat: card.stat,
                    playerId: playerID,
                    line: line,
                    overUnder: decision == .up ? .over : .under
                )
            case .pvpProp:
                guard let playerOne = card.playerOne, let playerOneID = playerOne.id,
                      let playerTwo = card.playerTwo, let playerTwoID = playerTwo.id else { return nil }
                let selectedID = decision == .up ? playerOneID : playerTwoID
                return .pvpProp(
                    userId: userId,
                    stat: card.stat,
                    playerOneId: playerOneID,
                    playerTwoId: playerTwoID,
                    selectedPlayerId: selectedID
                )
            }
        }
    }
}

#if DEBUG
extension PropCardsViewModel {
    /// Preview-only factory — seeds propCards and decisions directly, bypassing
    /// the Firestore fetch, since propCards' setter isn't accessible outside this file.
    static func mockForPreview() -> PropCardsViewModel {
        let vm = PropCardsViewModel()
        vm.propCards = [.mockSingle, .mockPVP]
        vm.decisions = [
            PropCard.mockSingle.id: .up,
            PropCard.mockPVP.id: .down
        ]
        return vm
    }
}
#endif
