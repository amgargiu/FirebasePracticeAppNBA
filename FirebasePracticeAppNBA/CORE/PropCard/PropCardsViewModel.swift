//
//  PropCardsViewModel.swift
//  FirebasePracticeAppNBA
//
//  Created by Antonio Gargiulo on 8/1/26.
//

import Foundation

@MainActor
final class PropCardsViewModel: ObservableObject {
    
    // Which pack template this session came from (e.g. "pack-1") — stable,
    // shared by every opening of that same pack.
    let packId: String
    
    // Unique to this specific opening — generated fresh the moment this view
    // model is created, so every PickModel produced during this session
    // (however many cards get skipped, re-decided, or edited) shares one id.
    let packOpeningId: String = UUID().uuidString
    
    init(packId: String) {
        self.packId = packId
    }
    
    @Published private(set) var propCards: [PropCard] = []
    
    // The single source of truth for what's been decided, shared across the
    // swipe stack and the review screen — not duplicated into a separate
    // PickModel array, since PickModel is just this data resolved on demand.
    @Published var decisions: [String: CardDecision] = [:]
    
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
                    packId: packId,
                    packOpeningId: packOpeningId,
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
                    packId: packId,
                    packOpeningId: packOpeningId,
                    stat: card.stat,
                    playerOneId: playerOneID,
                    playerTwoId: playerTwoID,
                    selectedPlayerId: selectedID
                )
            }
        }
    }
    
    // MARK: - Submission
    
    @Published private(set) var isUploading = false
    @Published var uploadError: String? = nil
    @Published private(set) var didUploadSuccessfully = false
    
    /// Resolves the current decisions into PickModels and uploads all of them.
    /// Drives isUploading/uploadError so the review screen can show progress
    /// and surface a failure without needing its own view model.
    func submitPicks() async {
        isUploading = true
        uploadError = nil
        
        do {
            let picks = try resolvePicks()
            print("Resolved \(picks.count) picks ready for upload: \(picks)")
            try await PickManager.shared.uploadPicks(picks: picks)
            didUploadSuccessfully = true
        } catch {
            uploadError = error.localizedDescription
        }
        
        isUploading = false
    }
}

#if DEBUG
extension PropCardsViewModel {
    /// Preview-only factory — seeds propCards and decisions directly, bypassing
    /// the Firestore fetch, since propCards' setter isn't accessible outside this file.
    static func mockForPreview() -> PropCardsViewModel {
        let vm = PropCardsViewModel(packId: "pack-1")
        vm.propCards = [.mockSingle, .mockPVP]
        vm.decisions = [
            PropCard.mockSingle.id: .up,
            PropCard.mockPVP.id: .down
        ]
        return vm
    }
}
#endif
