//
//  PickRowView.swift
//  FirebasePracticeAppNBA
//
//  Created by Antonio Gargiulo on 8/2/26.
//

import SwiftUI

struct PickRowView: View {
    
    let card: PropCard
    let decision: CardDecision
    let onToggle: () -> Void
    
    // The player whose identity drives the left side of the row.
    // Single player prop: always that one player.
    // PVP prop: whichever player is currently selected by the decision.
    private var displayPlayer: PlayerModel? {
        switch card.cardType {
        case .singlePlayerProp:
            return card.player
        case .pvpProp:
            return decision == .up ? card.playerOne : card.playerTwo
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
            
            trailingControl
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
    // Same format for every PickModel entry — single player shows the line,
    // PVP just shows the stat name since there's no line to compare against.
    
    @ViewBuilder
    private var statRow: some View {
        switch card.cardType {
        case .singlePlayerProp:
            if let line = card.line {
                Text("\(String(format: "%.1f", line)) \(card.stat.displayName)")
                    .font(.subheadline.bold())
            }
        case .pvpProp:
            Text(card.stat.displayName)
                .font(.subheadline.bold())
        }
    }
    
    // MARK: - Trailing Control
    
    @ViewBuilder
    private var trailingControl: some View {
        switch card.cardType {
        case .singlePlayerProp:
            singlePlayerToggle
        case .pvpProp:
            pvpImageToggle
        }
    }
    
    private var singlePlayerToggle: some View {
        Button(action: onToggle) {
            ZStack {
                Circle()
                    .fill(decision == .up ? Color.green : Color.red)
                    .frame(width: 44, height: 44)
                
                Image(systemName: "arrow.up")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                    .rotationEffect(.degrees(decision == .up ? 0 : 180))
            }
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.35, dampingFraction: 0.6), value: decision)
    }
    
    @ViewBuilder
    private var pvpImageToggle: some View {
        if let playerOne = card.playerOne, let playerTwo = card.playerTwo {
            HStack(spacing: 8) {
                pvpPlayerButton(player: playerOne, isSelected: decision == .up) {
                    if decision != .up { onToggle() }
                }
                pvpPlayerButton(player: playerTwo, isSelected: decision == .down) {
                    if decision != .down { onToggle() }
                }
            }
        }
    }
    
    private func pvpPlayerButton(player: PlayerModel, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            AsyncImage(url: URL(string: player.image ?? "")) { phase in
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
        .buttonStyle(.plain)
    }
}

// MARK: - Previews

#Preview("Single Player Row") {
    PickRowView(card: .mockSingle, decision: .up, onToggle: {})
        .padding()
}

#Preview("PVP Row") {
    PickRowView(card: .mockPVP, decision: .down, onToggle: {})
        .padding()
}
