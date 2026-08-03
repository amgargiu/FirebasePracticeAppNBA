//
//  PropCardsView.swift
//  FirebasePracticeAppNBA
//
//  Created by Antonio Gargiulo on 8/2/26.
//

enum CardDecision: Equatable {
    case none
    case up
    case down
}

import SwiftUI

struct PropCardsView: View {
    
    @StateObject var vm = PropCardsViewModel()
    
    // The full, stable set — used only to render the indicator row (always shows all cards)
    var allCards: [PropCard] {
        vm.propCards
    }
    
    // The live, shrinking navigable stack. Deciding removes a card for good;
    // skipping rotates it to the back so it resurfaces later.
    @State var queue: [PropCard] = []
    
    @State private var dragOffset: CGSize = .zero
    
    // Since there's no natural "peek" slot behind the current card, this stages
    // the departing card into a receding "behind the stack" position whenever
    // it advances forward — swipe-left, swipe-up, or swipe-down.
    @State private var recedingCard: PropCard? = nil
    @State private var recedingOffset: CGSize = .zero
    @State private var recedingScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                if allCards.isEmpty {
                    ProgressView()
                } else if queue.isEmpty {
                    ReviewPicksView(vm: vm)
                } else {
                    cardStack
                }
                
                Spacer()
                
                if !allCards.isEmpty && !queue.isEmpty {
                    indicatorRow
                        .padding(.bottom, 20)
                }
            }
            
            // Directional glow overlays
            topGlow
            bottomGlow
        }
        .task {
            vm.loadPropCards()
        }
        .onReceive(vm.$propCards) { newCards in
            // Seed the queue once, the first time cards arrive
            if queue.isEmpty && !newCards.isEmpty {
                queue = newCards
            }
        }
    }
    
    // MARK: - Card Stack
    
    private var visibleQueueCards: [(offset: Int, card: PropCard)] {
        var result: [(offset: Int, card: PropCard)] = []
        if queue.count > 1 {
            result.append((offset: 1, card: queue[1]))
        }
        if let first = queue.first {
            result.append((offset: 0, card: first))
        }
        return result
    }
    
    private var cardStack: some View {
        ZStack {
            recedingCardLayer
            
            ForEach(visibleQueueCards, id: \.card.id) { item in
                let isCurrent = item.offset == 0
                
                PropCardView(propCard: item.card)
                    .scaleEffect(isCurrent ? 1.0 : 0.95)
                    .offset(isCurrent ? dragOffset : CGSize(width: 0, height: 30))
                    .rotationEffect(.degrees(isCurrent ? rotationAngle : 0), anchor: .bottom)
                    .zIndex(isCurrent ? 1 : 0)
                    .simultaneousGesture(
                        DragGesture()
                            .onChanged { value in
                                guard isCurrent else { return }
                                dragOffset = value.translation
                            }
                            .onEnded { value in
                                guard isCurrent else { return }
                                handleSwipe(value.translation)
                            }
                    )
                    .animation(.spring(response: 0.4, dampingFraction: 0.75), value: queue.first?.id)
                    .transition(.scale(scale: 0.95).combined(with: .opacity))
            }
        }
    }
    
    // A standalone layer for the forward-swipe case — a departing card that
    // briefly animates into the "behind the stack" position before disappearing.
    @ViewBuilder
    private var recedingCardLayer: some View {
        if let recedingCard {
            PropCardView(propCard: recedingCard)
                .scaleEffect(recedingScale)
                .offset(recedingOffset)
                .zIndex(-1)
                .allowsHitTesting(false)
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
            .allowsHitTesting(false)
            
            Spacer()
        }
        .ignoresSafeArea(.container, edges: .top)
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
            .allowsHitTesting(false)
        }
        .ignoresSafeArea(.container, edges: .bottom)
    }
    
    // MARK: - Swipe Handling
    
    private func handleSwipe(_ translation: CGSize) {
        let horizontalThreshold: CGFloat = 80
        let verticalThreshold: CGFloat = 80
        let flyDistance: CGFloat = 600
        
        guard let currentCard = queue.first else { return }
        
        let isHorizontal = abs(translation.width) > abs(translation.height)
        var didSwipe = false
        var isSkip = false
        var flyOffTarget: CGSize = .zero
        var advance: () -> Void = {}
        
        if isHorizontal {
            if translation.width < -horizontalThreshold {
                flyOffTarget = CGSize(width: -flyDistance, height: translation.height)
                advance = { skipCurrent() }
                isSkip = true
                didSwipe = true
            }
            // Right swipe intentionally does nothing — no backward navigation.
            // Skipped cards rotate to the back of the queue and resurface naturally.
        } else {
            if translation.height < -verticalThreshold {
                vm.decisions[currentCard.id] = .up
                flyOffTarget = CGSize(width: translation.width, height: -flyDistance)
                advance = { decideCurrent() }
                didSwipe = true
            } else if translation.height > verticalThreshold {
                vm.decisions[currentCard.id] = .down
                flyOffTarget = CGSize(width: translation.width, height: flyDistance)
                advance = { decideCurrent() }
                didSwipe = true
            }
        }
        
        if didSwipe {
            // Phase 1: card flies fully off-screen
            withAnimation(.easeOut(duration: 0.25)) {
                dragOffset = flyOffTarget
            }
            
            // Phase 2: only a skip stages the departing card into the receding
            // "behind the stack" position — a decision just finishes flying off.
            let delay = isSkip ? 0.25 : 0.1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                if isSkip {
                    recedingCard = currentCard
                    recedingOffset = flyOffTarget
                    recedingScale = 1.0
                    
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                        advance()
                        dragOffset = .zero
                        recedingOffset = CGSize(width: 0, height: 30)
                        recedingScale = 0.95
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        recedingCard = nil
                    }
                } else {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                        advance()
                        dragOffset = .zero
                    }
                }
            }
        } else {
            // Didn't clear the threshold — spring back to center
            withAnimation(.spring()) {
                dragOffset = .zero
            }
        }
    }
    
    // Skip — moves the current card to the back of the queue so it resurfaces later
    private func skipCurrent() {
        guard !queue.isEmpty else { return }
        let card = queue.removeFirst()
        queue.append(card)
    }
    
    // Decision — removes the current card from the queue for good
    private func decideCurrent() {
        guard !queue.isEmpty else { return }
        queue.removeFirst()
    }
}

#Preview {
    PropCardsView()
}


import SwiftUI

extension PropCardsView {
    
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
