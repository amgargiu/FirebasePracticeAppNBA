//
//  ReviewPicksView.swift
//  FirebasePracticeAppNBA
//
//  Created by Antonio Gargiulo on 8/2/26.
//

import SwiftUI

struct ReviewPicksView: View {
    
    @ObservedObject var vm: PropCardsViewModel
    @Environment(\.dismiss) private var dismiss
    
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
            Task {
                await vm.submitPicks()
                if vm.didUploadSuccessfully {
                    dismiss()
                }
            }
        }) {
            if vm.isUploading {
                ProgressView()
                    .tint(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(16)
            } else {
                Text("Confirm & Submit")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(16)
            }
        }
        .disabled(vm.isUploading)
        .alert("Something went wrong", isPresented: .constant(vm.uploadError != nil), actions: {
            Button("OK") {
                vm.uploadError = nil
            }
        }, message: {
            Text(vm.uploadError ?? "")
        })
    }
}

// MARK: - Preview

#Preview {
    ReviewPicksView(vm: .mockForPreview())
}
