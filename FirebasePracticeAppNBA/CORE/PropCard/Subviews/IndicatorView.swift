//
//  IndicatorView.swift
//  FirebasePracticeAppNBA
//
//  Created by Antonio Gargiulo on 8/3/26.
//

import Foundation
import SwiftUI

extension PropCardsStackView {
    
    // MARK: - Indicator Row
    
    var indicatorRow: some View {
        HStack(spacing: 14) {
            ForEach(allCards, id: \.id) { card in
                indicatorDot(for: card)
            }
        }
    }
    
    private func indicatorDot(for card: PropCard) -> some View {
        let isDecided = vm.decisions[card.id, default: .none] != .none
        let isCurrent = card.id == queue.first?.id
        
        return ZStack {
            Circle()
                .fill(isDecided ? Color.accentColor : Color.gray.opacity(0.3))
                .frame(width: 16, height: 16)
            
            if isDecided {
                Image(systemName: "checkmark")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundStyle(.white)
            }
        }
        .overlay(
            Circle()
                .stroke(Color.primary.opacity(isCurrent ? 0.6 : 0), lineWidth: 1.5)
                .frame(width: 22, height: 22)
        )
        .animation(.easeInOut, value: vm.decisions[card.id, default: .none])
        .animation(.easeInOut, value: isCurrent)
    }
}
