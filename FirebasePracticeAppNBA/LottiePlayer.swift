//
//  LottieTestView.swift
//  FirebasePracticeAppNBA
//
//  Created by Antonio Gargiulo on 8/7/26.
//

import SwiftUI
import Lottie

import SwiftUI
import Lottie

/// Plays a Lottie animation from a .lottie package (dotLottie format).
///
/// Uses the dedicated async DotLottieFile API rather than the simpler
/// LottieAnimation.named(_:) path. Despite that simpler API's documentation
/// claiming it auto-detects both .json and .lottie, it's unreliable for
/// .lottie packages in practice — this is a known, widely-reported issue,
/// not something specific to any one file. DotLottieFile.named(_:) is the
/// actually-reliable path for packaged .lottie files specifically.
struct LottiePlayer: View {
    
    /// Must match the .lottie file's name in the project (without extension).
    let animationName: String
    
    var loopMode: LottieLoopMode = .loop
    var animationSpeed: CGFloat = 1
    var contentMode: ContentMode = .fit
    
    var body: some View {
        LottieView {
            try await DotLottieFile.named(animationName)
        } placeholder: {
            ProgressView()
        }
        .playing(loopMode: loopMode)
        .animationSpeed(animationSpeed)
        .resizable()
        .aspectRatio(contentMode: contentMode)
    }
}

#Preview {
    LottiePlayer(animationName: "Star rating 1")
        .frame(width: 200, height: 200)
}
