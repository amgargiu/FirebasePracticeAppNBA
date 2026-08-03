//
//  ReviewPicksView.swift
//  FirebasePracticeAppNBA
//
//  Created by Antonio Gargiulo on 8/2/26.
//

import SwiftUI

struct ReviewPicksView: View {
    
    @ObservedObject var vm: PropCardsViewModel
    
    private var decidedCards: [PropCard] {
        vm.propCards.filter { vm.decisions[$0.id, default: .none] != .none }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Review Your Picks")
                .font(.title2.bold())
                .padding(.top, 24)
                .padding(.bottom, 12)
            
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(decidedCards) { card in
                        if let decision = vm.decisions[card.id], decision != .none {
                            PickRowView(
                                card: card,
                                decision: decision,
                                onToggle: {
                                    vm.toggleDecision(for: card)
                                }
                            )
                        }
                    }
                }
                .padding()
            }
            
            confirmButton
                .padding()
        }
    }
    
    private var confirmButton: some View {
        Button(action: {
            do {
                let picks = try vm.resolvePicks()
                print("Resolved \(picks.count) picks ready for upload: \(picks)")
            } catch {
                // TODO: surface this to the user (e.g. an alert) once sign-in is wired up —
                // for now this only fires if someone reaches this screen while signed out
                print("Failed to resolve picks: \(error)")
            }
        }) {
            Text("Confirm & Submit")
                .font(.title2.bold())
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(16)
        }
    }
}

// MARK: - Preview

#Preview {
    ReviewPicksView(vm: .mockForPreview())
}
