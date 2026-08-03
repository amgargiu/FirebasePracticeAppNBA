//
//  PackOpeningView.swift
//  FirebasePracticeAppNBA
//
//  Created by Antonio Gargiulo on 8/3/26.
//

import SwiftUI

private enum PackOpeningPhase {
    case entering
    case shaking
    case popping
    case revealed
}

struct PackOpeningView: View {
    
    let packImageName: String
    
    @State private var phase: PackOpeningPhase = .entering
    @State private var packOffset: CGFloat = 400
    @State private var packOpacity: Double = 0
    @State private var packRotation: Double = 0
    @State private var packScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            if phase == .revealed {
                PropCardsView()
                    .transition(.opacity)
            } else {
                PackBackground()
                
                Image(packImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 220, height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .black.opacity(0.4), radius: 20, y: 10)
                    .offset(y: packOffset)
                    .opacity(packOpacity)
                    .rotationEffect(.degrees(packRotation))
                    .scaleEffect(packScale)
            }
        }
        .task {
            await runSequence()
        }
    }
    
    // MARK: - Animation Sequence
    
    private func runSequence() async {
        // Phase 1: slide up from off-screen bottom
        withAnimation(.spring(response: 0.6, dampingFraction: 0.75)) {
            packOffset = 0
            packOpacity = 1
        }
        
        try? await Task.sleep(nanoseconds: 700_000_000)
        
        // Phase 2: shake — quick back-and-forth rotation, anticipation beat
        phase = .shaking
        for _ in 0..<3 {
            withAnimation(.easeInOut(duration: 0.08)) {
                packRotation = -8
            }
            try? await Task.sleep(nanoseconds: 80_000_000)
            
            withAnimation(.easeInOut(duration: 0.08)) {
                packRotation = 8
            }
            try? await Task.sleep(nanoseconds: 80_000_000)
        }
        withAnimation(.easeInOut(duration: 0.1)) {
            packRotation = 0
        }
        
        try? await Task.sleep(nanoseconds: 200_000_000)
        
        // Phase 3: pop — scale up and fade the pack, then reveal PropCardsView
        // underneath, which shares the exact same gradient background.
        phase = .popping
        withAnimation(.easeOut(duration: 0.35)) {
            packScale = 1.4
            packOpacity = 0
        }
        
        try? await Task.sleep(nanoseconds: 350_000_000)
        
        withAnimation(.easeInOut(duration: 0.3)) {
            phase = .revealed
        }
    }
}

#Preview {
    PackOpeningView(packImageName: "pack-1")
}
