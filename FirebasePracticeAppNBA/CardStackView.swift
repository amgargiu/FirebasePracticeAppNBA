//
//  CardStackView.swift
//  FirebasePracticeAppNBA
//
//  Created by Antonio Gargiulo on 8/1/26.
//

import SwiftUI

// MARK: - Decision Tracking

enum CardDecision: Equatable {
    case none
    case up
    case down
}

struct CardStackView: View {
    
    private let cardNumbers = Array(0..<7)
    private let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple, .pink]
    
    @State private var currentIndex = 0
    @State private var dragOffset: CGSize = .zero
    @State private var decisions: [CardDecision] = Array(repeating: .none, count: 7)
    
    private var allDecided: Bool {
        decisions.allSatisfy { $0 != .none }
    }
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                if allDecided {
                    submitButton
                } else {
                    cardStack
                }
                
                Spacer()
                
                indicatorRow
                    .padding(.bottom, 40)
            }
            
            // Directional glow overlays
            topGlow
            bottomGlow
        }
    }
    
    // MARK: - Card Stack
    
    private var cardStack: some View {
        ZStack {
            // Peek of the next card, sitting behind and slightly below the current one
            if currentIndex + 1 < cardNumbers.count {
                let nextNumber = cardNumbers[currentIndex + 1]
                RoundedRectangle(cornerRadius: 24)
                    .fill(colors[nextNumber % colors.count])
                    .frame(width: 340, height: 480)
                    .overlay(
                        Text("Card \(nextNumber + 1)")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                    )
                    .scaleEffect(0.95)
                    .offset(y: 30)
            }
            
            ForEach(cardNumbers, id: \.self) { number in
                if number == currentIndex {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(colors[number % colors.count])
                        .frame(width: 340, height: 480)
                        .overlay(
                            Text("Card \(number + 1)")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(.white)
                        )
                        .offset(dragOffset)
                        .rotationEffect(.degrees(rotationAngle), anchor: .bottom)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    dragOffset = value.translation
                                }
                                .onEnded { value in
                                    handleSwipe(value.translation)
                                }
                        )
                        .animation(.spring(), value: dragOffset)
                        .transition(.opacity)
                }
            }
        }
    }
    
    // Tinder-style tilt based on horizontal drag amount
    private var rotationAngle: Double {
        Double(dragOffset.width / 15)
    }
    
    // MARK: - Glow Overlays
    
    private var topGlowOpacity: Double {
        guard dragOffset.height < 0 else { return 0 }
        return min(Double(-dragOffset.height) / 200, 1.0)
    }
    
    private var bottomGlowOpacity: Double {
        guard dragOffset.height > 0 else { return 0 }
        return min(Double(dragOffset.height) / 200, 1.0)
    }
    
    private var topGlow: some View {
        VStack {
            LinearGradient(
                colors: [Color.green.opacity(topGlowOpacity), .clear],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 180)
            .ignoresSafeArea()
            .allowsHitTesting(false)
            
            Spacer()
        }
    }
    
    private var bottomGlow: some View {
        VStack {
            Spacer()
            
            LinearGradient(
                colors: [.clear, Color.red.opacity(bottomGlowOpacity)],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 180)
            .ignoresSafeArea()
            .allowsHitTesting(false)
        }
    }
    
    // MARK: - Indicator Row
    
    private var indicatorRow: some View {
        HStack(spacing: 8) {
            ForEach(cardNumbers, id: \.self) { number in
                Circle()
                    .fill(indicatorColor(for: decisions[number]))
                    .frame(width: number == currentIndex ? 10 : 8, height: number == currentIndex ? 10 : 8)
                    .overlay(
                        Circle()
                            .stroke(Color.primary.opacity(number == currentIndex ? 0.6 : 0), lineWidth: 1.5)
                            .frame(width: 16, height: 16)
                    )
                    .animation(.easeInOut, value: decisions[number])
                    .animation(.easeInOut, value: currentIndex)
            }
        }
    }
    
    private func indicatorColor(for decision: CardDecision) -> Color {
        switch decision {
        case .none: return .gray.opacity(0.4)
        case .up: return .green
        case .down: return .red
        }
    }
    
    // MARK: - Submit Button
    
    private var submitButton: some View {
        Button(action: {
            print("Submitted decisions: \(decisions)")
        }) {
            Text("Submit")
                .font(.title2.bold())
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(16)
        }
        .padding(.horizontal, 40)
    }
    
    // MARK: - Swipe Handling
    
    private func handleSwipe(_ translation: CGSize) {
        let horizontalThreshold: CGFloat = 80
        let verticalThreshold: CGFloat = 80
        
        if abs(translation.width) > abs(translation.height) {
            // Left / Right — navigate only, no decision made
            if translation.width < -horizontalThreshold {
                goForward()
            } else if translation.width > horizontalThreshold {
                goBackward()
            }
        } else {
            // Up / Down — records a decision, then advances
            if translation.height < -verticalThreshold {
                decisions[currentIndex] = .up
                goForward()
            } else if translation.height > verticalThreshold {
                decisions[currentIndex] = .down
                goForward()
            }
        }
        
        withAnimation(.spring()) {
            dragOffset = .zero
        }
    }
    
    private func goForward() {
        if currentIndex < cardNumbers.count - 1 {
            currentIndex += 1
        } else if let firstUndecided = decisions.firstIndex(where: { $0 == .none }) {
            // Reached the end — loop back to the first undecided card
            currentIndex = firstUndecided
        }
        // If everything is decided, allDecided flips true and the submit button takes over
    }
    
    private func goBackward() {
        if currentIndex > 0 {
            currentIndex -= 1
        }
    }
}

#Preview {
    CardStackView()
}
