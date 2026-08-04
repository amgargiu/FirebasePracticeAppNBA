//
//  SettledPickRowView.swift
//  FirebasePracticeAppNBA
//
//  Created by Antonio Gargiulo on 8/4/26.
//

import SwiftUI

struct SettledPickRowView: View {
    
    let pick: PickModel
    let playersById: [Int: PlayerModel]
    
    // The player whose identity drives the left side of the row — same
    // convention as PickRowView: single player prop uses that one player,
    // PVP prop uses whichever player was actually selected.
    private var displayPlayer: PlayerModel? {
        switch pick.cardType {
        case .singlePlayerProp:
            guard let id = pick.playerId else { return nil }
            return playersById[id]
        case .pvpProp:
            guard let id = pick.selectedPlayerId else { return nil }
            return playersById[id]
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            headshot
            
            VStack(alignment: .leading, spacing: 4) {
                nameRow
                gameInfoRow
                statRow
            }
            
            Spacer()
            
            trailingBadge
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.secondarySystemBackground))
        )
    }
    
    // MARK: - Headshot
    
    private var headshot: some View {
        AsyncImage(url: URL(string: displayPlayer?.image ?? "")) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFill()
            } else {
                Color.clear
            }
        }
        .frame(width: 50, height: 50)
        .background(Color.gray.opacity(0.25))
        .clipShape(Circle())
    }
    
    // MARK: - Name Row
    
    private var nameRow: some View {
        HStack(spacing: 6) {
            AsyncImage(url: URL(string: displayPlayer?.teamImage ?? "")) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                }
            }
            .frame(width: 16, height: 16)
            
            Text(displayPlayer?.displayName ?? "Unknown")
                .font(.subheadline.bold())
                .lineLimit(1)
                .minimumScaleFactor(0.75)
                .layoutPriority(1)
            
            Text(displayPlayer?.displayPosition ?? "")
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize()
        }
    }
    
    // MARK: - Game Info Row
    
    private var gameInfoRow: some View {
        Text("\(displayPlayer?.displayTeam ?? "") @ \(displayPlayer?.displayOpp ?? "")  •  \(displayPlayer?.displayTime ?? "")")
            .font(.caption)
            .foregroundStyle(.secondary)
            .lineLimit(1)
    }
    
    // MARK: - Stat Row
    
    @ViewBuilder
    private var statRow: some View {
        switch pick.cardType {
        case .singlePlayerProp:
            if let line = pick.line {
                Text("\(String(format: "%.1f", line)) \(pick.stat.displayName)")
                    .font(.subheadline.bold())
            }
        case .pvpProp:
            Text(pick.stat.displayName)
                .font(.subheadline.bold())
        }
    }
    
    // MARK: - Trailing Badge
    
    @ViewBuilder
    private var trailingBadge: some View {
        switch pick.cardType {
        case .singlePlayerProp:
            if let overUnder = pick.overUnder {
                singlePlayerBadge(isOver: overUnder == .over)
            }
        case .pvpProp:
            pvpBadge
        }
    }
    
    private func singlePlayerBadge(isOver: Bool) -> some View {
        ZStack {
            Circle()
                .fill(isOver ? Color.green : Color.red)
                .frame(width: 44, height: 44)
            
            Image(systemName: "arrow.up")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.white)
                .rotationEffect(.degrees(isOver ? 0 : 180))
        }
    }
    
    @ViewBuilder
    private var pvpBadge: some View {
        if let playerOneId = pick.playerOneId, let playerTwoId = pick.playerTwoId {
            HStack(spacing: 8) {
                pvpPlayerImage(playerId: playerOneId, isSelected: pick.selectedPlayerId == playerOneId)
                pvpPlayerImage(playerId: playerTwoId, isSelected: pick.selectedPlayerId == playerTwoId)
            }
        }
    }
    
    private func pvpPlayerImage(playerId: Int, isSelected: Bool) -> some View {
        AsyncImage(url: URL(string: playersById[playerId]?.image ?? "")) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFill()
            } else {
                Color.clear
            }
        }
        .frame(width: 44, height: 44)
        .background(Color.gray.opacity(0.25))
        .clipShape(Circle())
        .saturation(isSelected ? 1.0 : 0.0)
        .opacity(isSelected ? 1.0 : 0.5)
        .overlay(
            Circle()
                .stroke(isSelected ? Color.accentColor : Color.clear, lineWidth: 2)
        )
    }
}

// MARK: - Previews

#Preview("Single Player Settled Row") {
    SettledPickRowView(
        pick: .singlePlayerProp(
            userId: "mock",
            packId: "pack-1",
            packOpeningId: "mock-opening",
            stat: .reb,
            playerId: 1,
            line: 10.5,
            overUnder: .over
        ),
        playersById: [1: PlayerModel.mock(id: 1, name: "Victor Wembanyama", team: "SAS", opp: "MIN")]
    )
    .padding()
}

#Preview("PVP Settled Row") {
    SettledPickRowView(
        pick: .pvpProp(
            userId: "mock",
            packId: "pack-1",
            packOpeningId: "mock-opening",
            stat: .pts,
            playerOneId: 1,
            playerTwoId: 2,
            selectedPlayerId: 1
        ),
        playersById: [
            1: PlayerModel.mock(id: 1, name: "Cade Cunningham", team: "DET", opp: "CLE"),
            2: PlayerModel.mock(id: 2, name: "Donovan Mitchell", team: "CLE", opp: "@DET")
        ]
    )
    .padding()
}
