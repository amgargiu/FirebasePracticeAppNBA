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
    
    var body: some View {
        switch card.cardType {
        case .singlePlayerProp:
            singlePlayerRow
        case .pvpProp:
            pvpRow
        }
    }
    
    // MARK: - Single Player Prop
    
    @ViewBuilder
    private var singlePlayerRow: some View {
        if let player = card.player, let line = card.line {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(player.displayName)
                        .font(.subheadline.bold())
                    Text("\(card.stat.rawValue)  \(String(format: "%.1f", line))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Button(action: onToggle) {
                    Text(decision == .up ? "OVER" : "UNDER")
                        .font(.caption.bold())
                        .foregroundStyle(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(decision == .up ? Color.green : Color.red)
                        )
                }
                .buttonStyle(.plain)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(.secondarySystemBackground))
            )
        }
    }
    
    // MARK: - PVP Prop
    
    @ViewBuilder
    private var pvpRow: some View {
        if let playerOne = card.playerOne, let playerTwo = card.playerTwo {
            HStack(spacing: 12) {
                Text(card.stat.rawValue)
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
                    .frame(width: 40, alignment: .leading)
                
                Button(action: {
                    if decision != .up { onToggle() }
                }) {
                    Text(playerOne.displayName)
                        .font(.subheadline.bold())
                        .foregroundStyle(decision == .up ? .white : .primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(decision == .up ? Color.accentColor : Color(.tertiarySystemBackground))
                        )
                }
                .buttonStyle(.plain)
                
                Text("vs")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Button(action: {
                    if decision != .down { onToggle() }
                }) {
                    Text(playerTwo.displayName)
                        .font(.subheadline.bold())
                        .foregroundStyle(decision == .down ? .white : .primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(decision == .down ? Color.accentColor : Color(.tertiarySystemBackground))
                        )
                }
                .buttonStyle(.plain)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(.secondarySystemBackground))
            )
        }
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
