//
//  PickGroupView.swift
//  FirebasePracticeAppNBA
//
//  Created by Antonio Gargiulo on 8/4/26.
//

import SwiftUI

struct PickGroupView: View {
    
    let group: PickGroup
    let playersById: [Int: PlayerModel]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            header
            
            VStack(spacing: 10) {
                ForEach(group.picks) { pick in
                    SettledPickRowView(pick: pick, playersById: playersById)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(.tertiarySystemBackground))
        )
    }
    
    // MARK: - Header
    
    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(group.pack.displayName)
                    .font(.headline.bold())
                Text(group.id)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .truncationMode(.middle)
            }
            
            Spacer()
            
            Image(group.pack.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 44, height: 44)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

#Preview {
    PickGroupView(
        group: PickGroup(
            id: "mock-opening-1",
            pack: PackModel.allPacks[0],
            picks: [
                .singlePlayerProp(
                    userId: "mock",
                    packId: "pack-1",
                    packOpeningId: "mock-opening-1",
                    stat: .reb,
                    playerId: 1,
                    line: 10.5,
                    overUnder: .over
                ),
                .pvpProp(
                    userId: "mock",
                    packId: "pack-1",
                    packOpeningId: "mock-opening-1",
                    stat: .pts,
                    playerOneId: 2,
                    playerTwoId: 3,
                    selectedPlayerId: 2
                )
            ],
            dateCreated: Date()
        ),
        playersById: [
            1: PlayerModel.mock(id: 1, name: "Victor Wembanyama", team: "SAS", opp: "MIN"),
            2: PlayerModel.mock(id: 2, name: "Cade Cunningham", team: "DET", opp: "CLE"),
            3: PlayerModel.mock(id: 3, name: "Donovan Mitchell", team: "CLE", opp: "@DET")
        ]
    )
    .padding()
}
