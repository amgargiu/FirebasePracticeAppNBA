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
    
    @State private var isExpanded: Bool
    
    init(group: PickGroup, playersById: [Int: PlayerModel], isInitiallyExpanded: Bool = false) {
        self.group = group
        self.playersById = playersById
        _isExpanded = State(initialValue: isInitiallyExpanded)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            header
            picksSection
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)))
        )
    }
    
    // MARK: - Picks Section
    
    // Always present in the tree — expand/collapse is a continuous frame-height
    // + opacity animation, not an insertion/removal transition. A transition
    // here would animate relative to the view's container bounds, which reads
    // as "flying in from off-screen" rather than growing out of the header.
    private var picksSection: some View {
        VStack(spacing: 10) {
            ForEach(group.picks) { pick in
                SettledPickRowView(pick: pick, playersById: playersById)
            }
        }
        .frame(maxHeight: isExpanded ? nil : 0, alignment: .top)
        .opacity(isExpanded ? 1 : 0)
        .clipped()
    }
    
    // MARK: - Header
    
    private var header: some View {
        HStack {
            Image(systemName: "chevron.right")
                .font(.caption.bold())
                .foregroundStyle(.secondary)
                .rotationEffect(.degrees(isExpanded ? 90 : 0))
            
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
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.25)) {
                isExpanded.toggle()
            }
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
        ],
        isInitiallyExpanded: true
    )
    .padding()
}
