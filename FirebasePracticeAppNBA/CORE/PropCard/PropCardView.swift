//
//  PropCardView.swift
//  FirebasePracticeAppNBA
//
//  Created by Antonio Gargiulo on 8/1/26.
//
import SwiftUI

struct PropCardView: View {
    
    let propCard: PropCard
    
    var body: some View {
        switch propCard.cardType {
        case .singlePlayerProp:
            singlePlayerContent
        case .pvpProp:
            pvpContent
        }
    }
    
    // MARK: - Single Player Prop
    
    @ViewBuilder
    private var singlePlayerContent: some View {
        if let player = propCard.player, let line = propCard.line {
            ZStack {
                // Split background — green/black radial on top, red/black radial on bottom
                VStack(spacing: 0) {
                    RadialGradient(
                        colors: [Color.green, .black],
                        center: .center,
                        startRadius: 20,
                        endRadius: 400
                    )
                    .frame(height: 325)
                    
                    RadialGradient(
                        colors: [Color.red, .black],
                        center: .center,
                        startRadius: 20,
                        endRadius: 400
                    )
                    .frame(height: 325)
                }
                
                
                // Player image + name, grouped so the name stays anchored to the image's bottom edge
                VStack(spacing: 6) {
                    AsyncImage(url: URL(string: player.image ?? "")) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFill()
                        } else {
                            Color.black.opacity(0.2)
                        }
                    }
                    .frame(width: 200, height: 400)
                    .offset(x: 0, y: -20)
                    
                    Text(player.displayName.uppercased())
                        .font(.system(size: 22, weight: .black))
                        .italic()
                        .foregroundStyle(.white)
                        .offset(x: 0, y: -20)
                }
                .offset(x: 0, y: -50)
                
                
                // Team logo, top right
                VStack {
                    HStack {
                        Spacer()
                        AsyncImage(url: URL(string: player.teamImage ?? "")) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFit()
                            }
                        }
                        .frame(width: 60, height: 60)
                    }
                    Spacer()
                }
                .padding()
                
                // OVER label, top left
                VStack {
                    HStack {
                        overUnderLabel(
                            title: "SWIPE UP",
                            overUnder: "OVER",
                            value: line,
                            stat: propCard.stat,
                            color: Color(#colorLiteral(red: 0.2678571428, green: 1, blue: 0.5401785714, alpha: 1)),
                            chevronsPointUp: true
                        )
                        Spacer()
                    }
                    Spacer()
                }
                .padding()
                
                // UNDER label, bottom right
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        overUnderLabel(
                            title: "SWIPE DOWN",
                            overUnder: "UNDER",
                            value: line,
                            stat: propCard.stat,
                            color: Color(#colorLiteral(red: 1, green: 0.6924721278, blue: 0.6488794916, alpha: 1)),
                            chevronsPointUp: false
                        )
                    }
                }
                .padding()
                
                
                // Thin divider line at the seam
                Rectangle()
                    .fill(Color.white)
                    .frame(height: 3)
                
                // Center stat badge — just the number and stat name now
                VStack(spacing: 2) {
                    
                    Text(String(format: "%.1f", line))
                        .font(.title2.bold())
                        .foregroundStyle(.black)
                    Text(propCard.stat.rawValue.uppercased())
                        .font(.headline.bold())
                        .foregroundStyle(.black)
                }
                .padding(10)
                .background(
                    Circle()
                        .fill(Color.white)
                )
            }
            .frame(width: 340, height: 650)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(
                        LinearGradient(colors: [Color(#colorLiteral(red: 0.2678571428, green: 1, blue: 0.5401785714, alpha: 1)), .red], startPoint: .top, endPoint: .bottom),
                        lineWidth: 4
                    )
            )
        }
    }
    
    private func overUnderLabel(
        title: String,
        overUnder: String,
        value: Double,
        stat: StatType,
        color: Color,
        chevronsPointUp: Bool
    ) -> some View {
        VStack(alignment: chevronsPointUp ? .leading : .trailing, spacing: 2) {
            HStack(spacing: 4) {
                Image(systemName: chevronsPointUp ? "chevron.up" : "chevron.down")
                Text(title)
            }
            .font(.caption.bold())
            .foregroundStyle(color)
            
            Text(overUnder)
                .font(.headline.bold())
                .foregroundStyle(color)
            Text(String(format: "%.1f", value))
                .font(.system(size: 36, weight: .heavy))
                .foregroundStyle(.white)
            Text(stat.displayName.uppercased())
                .font(.caption.bold())
                .foregroundStyle(color)
        }
        .scaleEffect(1.1)
    }
    
    // MARK: - PVP Prop
    
    @ViewBuilder
    private var pvpContent: some View {
        if let playerOne = propCard.playerOne, let playerTwo = propCard.playerTwo {
            ZStack {
                VStack(spacing: 0) {
                    pvpHalf(player: playerOne, stat: propCard.stat)
                    pvpHalf(player: playerTwo, stat: propCard.stat)
                }
                
                // Divider line at the seam between the two halves
                Rectangle()
                    .fill(Color.red)
                    .frame(height: 3)
                
                // VS divider badge, sits on the seam between the two halves
                Circle()
                    .fill(Color.black)
                    .frame(width: 44, height: 44)
                    .overlay(
                        Text("VS")
                            .font(.headline.bold())
                            .foregroundStyle(.white)
                    )
            }
            .frame(width: 340, height: 650)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color(playerOne.teamColor),
                                Color(playerTwo.teamColor)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 4
                    )
            )
        }
    }
    
    private func pvpHalf(player: PlayerModel, stat: StatType) -> some View {
        ZStack(alignment: .bottomTrailing) {
            RadialGradient(
                colors: [
                    Color(player.teamColor),
                    .black
                ],
                center: .bottomTrailing,
                startRadius: 20,
                endRadius: 1000
            )
            
            HStack(spacing: 0) {
                pvpStatsColumn(player: player, stat: stat)
                    .padding()
                
                Spacer(minLength: 0)
                
                // Headshot, shifted right and clipped to the half's frame
                AsyncImage(url: URL(string: player.image ?? "")) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFill()
                    } else {
                        Color.clear
                    }
                }
                .frame(width: 90)
//                .clipped()
            }
            
            // Team logo, top left
        }
        .frame(maxWidth: .infinity)
        .frame(height: 325)
        .clipped()
    }
    
    private func pvpStatsColumn(player: PlayerModel, stat: StatType) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            
            AsyncImage(url: URL(string: player.teamImage ?? "")) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                }
            }
            .frame(width: 60, height: 60)
            .padding(12)
            
            
            if let name = player.player {
                let parts = name.split(separator: " ")
                if let first = parts.first {
                    Text(String(first).uppercased())
                        .font(.headline)
                        .foregroundStyle(.white)
                }
                if parts.count > 1 {
                    Text(parts.dropFirst().joined(separator: " ").uppercased())
                        .font(.system(size: 24, weight: .black))
                        .italic()
                        .foregroundStyle(.white)

                }
            }
            
            
            Text(stat.displayName.uppercased())
                .font(.headline.bold())
                .foregroundStyle(.yellow)
                .padding(.top, 6)

            
            if let value = player.statValue(for: stat) {
                Text(String(format: "%.1f", value))
                    .font(.system(size: 44, weight: .heavy))
                    .foregroundStyle(Color(.white))
                    .italic(true)
            }
            
            Spacer()
        }
    }
}

// MARK: - Previews

#Preview("Single Player Prop") {
    PropCardView(
        propCard: .singlePlayerProp(
            stat: .reb,
            player: PlayerModel.mock(
                id: 1,
                name: "Victor Wembanyama",
                team: "SAS",
                opp: "MIN",
                pts: 24.3,
                image: "https://cdn.nba.com/headshots/nba/latest/1040x760/1641705.png",
                teamImage: "https://a.espncdn.com/i/teamlogos/nba/500/sa.png"
            ),
            line: 10.5
        )
    )
}

#Preview("PVP Prop") {
    PropCardView(
        propCard: .pvpProp(
            stat: .pts,
            playerOne: PlayerModel.mock(
                id: 1,
                name: "Cade Cunningham",
                team: "DET",
                opp: "CLE",
                pts: 24.5,
                image: "https://cdn.nba.com/headshots/nba/latest/1040x760/1630595.png",
                teamImage: "https://a.espncdn.com/i/teamlogos/nba/500/det.png"
            ),
            playerTwo: PlayerModel.mock(
                id: 2,
                name: "Donovan Mitchell",
                team: "CLE",
                opp: "@DET",
                pts: 25.5,
                image: "https://cdn.nba.com/headshots/nba/latest/1040x760/1628378.png",
                teamImage: "https://a.espncdn.com/i/teamlogos/nba/500/cle.png"
            )
        )
    )
}
