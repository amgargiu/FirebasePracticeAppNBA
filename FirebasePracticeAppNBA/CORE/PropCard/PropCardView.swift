//
//  PropCardView.swift
//  FirebasePracticeAppNBA
//
//  Created by Antonio Gargiulo on 8/1/26.
//

import SwiftUI

struct SinglePropCardView: View {
    
    let propCard: PropCard
    
    var body: some View {
        VStack {
            switch propCard.cardType {
            case .singlePlayerProp:
                singlePlayerContent
            case .pvpProp:
                pvpContent
            }
        }
    }
    
    @ViewBuilder
    private var singlePlayerContent: some View {
        if let player = propCard.player {
            Text(player.displayName)
                .font(.title2)
                .bold()
        }
    }
    
    @ViewBuilder
    private var pvpContent: some View {
        if let playerOne = propCard.playerOne, let playerTwo = propCard.playerTwo {
            VStack(spacing: 12) {
                Text(playerOne.displayName)
                    .font(.title2)
                    .bold()
                
                Text("vs")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text(playerTwo.displayName)
                    .font(.title2)
                    .bold()
            }
        }
    }
}

// MARK: - Sample Data for Previews



#Preview("Single Player Prop") {
    SinglePropCardView(
        propCard: .singlePlayerProp(
            stat: .pts,
            player: PlayerModel.mock(id: 1, name: "Alperen Sengun"),
            line: 20.5
        )
    )
}

#Preview("PVP Prop") {
    SinglePropCardView(
        propCard: .pvpProp(
            stat: .pts,
            playerOne: PlayerModel.mock(id: 1, name: "Alperen Sengun"),
            playerTwo: PlayerModel.mock(id: 2, name: "Amen Thompson")
        )
    )
}
