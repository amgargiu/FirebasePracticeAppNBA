//
//  MyPicksViewModel.swift
//  FirebasePracticeAppNBA
//
//  Created by Antonio Gargiulo on 8/4/26.
//

import Foundation

@MainActor
final class MyPicksViewModel: ObservableObject {
    
    @Published private(set) var pickGroups: [PickGroup] = []
    @Published private(set) var playersById: [Int: PlayerModel] = [:]
    
    @Published private(set) var isLoading = false
    @Published var loadError: String? = nil
    
    func loadPicks() async {
        isLoading = true
        loadError = nil
        
        do {
            let authResult = try AuthManager.shared.getAuthenticatedUser()
            let picks = try await PickManager.shared.getAllPicks(userId: authResult.uid)
            
            // Collect every unique player id referenced across all picks,
            // whether it's a single-player pick or a PVP pick with two players.
            var uniqueIds: Set<Int> = []
            for pick in picks {
                if let id = pick.playerId { uniqueIds.insert(id) }
                if let id = pick.playerOneId { uniqueIds.insert(id) }
                if let id = pick.playerTwoId { uniqueIds.insert(id) }
            }
            
            let players = try await PlayerManager.shared.getPlayers(ids: Array(uniqueIds))
            var lookup: [Int: PlayerModel] = [:]
            for player in players {
                if let id = player.id {
                    lookup[id] = player
                }
            }
            self.playersById = lookup
            
            self.pickGroups = groupPicks(picks)
        } catch {
            loadError = error.localizedDescription
        }
        
        isLoading = false
    }
    
    // MARK: - Grouping
    
    private func groupPicks(_ picks: [PickModel]) -> [PickGroup] {
        let grouped = Dictionary(grouping: picks, by: \.packOpeningId)
        
        let groups: [PickGroup] = grouped.compactMap { packOpeningId, picksInGroup in
            guard let firstPick = picksInGroup.first,
                  let pack = PackModel.allPacks.first(where: { $0.id == firstPick.packId }) else { return nil }
            
            let earliestDate = picksInGroup.compactMap(\.dateCreated).min()
            
            return PickGroup(
                id: packOpeningId,
                pack: pack,
                picks: picksInGroup,
                dateCreated: earliestDate
            )
        }
        
        // Most recent pack opening first
        return groups.sorted { ($0.dateCreated ?? .distantPast) > ($1.dateCreated ?? .distantPast) }
    }
}

#if DEBUG
extension MyPicksViewModel {
    static func mockForPreview() -> MyPicksViewModel {
        let vm = MyPicksViewModel()
        
        let mockPick = PickModel.singlePlayerProp(
            userId: "mock-user",
            packId: "pack-1",
            packOpeningId: "mock-opening-1",
            stat: .reb,
            playerId: 1,
            line: 10.5,
            overUnder: .over
        )
        
        vm.pickGroups = [
            PickGroup(id: "mock-opening-1", pack: PackModel.allPacks[0], picks: [mockPick], dateCreated: Date())
        ]
        vm.playersById = [1: PlayerModel.mock(id: 1, name: "Victor Wembanyama", team: "SAS", opp: "MIN")]
        
        return vm
    }
}
#endif
