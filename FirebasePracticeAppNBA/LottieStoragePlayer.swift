//
//  LottieSotragePlayer.swift
//  FirebasePracticeAppNBA
//
//  Created by Antonio Gargiulo on 8/8/26.
//

//
//  LottieStoragePlayer.swift
//  FirebasePracticeAppNBA
//
//  Created by Antonio Gargiulo on 8/8/26.
//
//
//  LottieStoragePlayer.swift
//  FirebasePracticeAppNBA
//
//  Created by Antonio Gargiulo on 8/8/26.
//

import SwiftUI
import Lottie


/// Plays a Lottie animation stored in the "LottieZips" folder in Firebase
/// Storage, referenced by filename. Chains two async steps into one
/// LottieView loading closure: resolve the Storage filename to a download
/// URL via StorageManager, then load that URL the same way LottiePlayerURL
/// does — no separate view model needed, since LottieView already owns the
/// full loading -> loaded lifecycle on its own.
///
/// Checks LottieAnimationCache first so repeat renders of the same
/// fileName (e.g. re-scrolling a grid, or the expanded detail view showing
/// the same animation again) skip both the Storage URL lookup and the
/// DotLottieFile fetch+parse entirely.
struct LottieStoragePlayer: View {
    
    /// The file's name inside the LottieZips folder, e.g. "cade-lottie.zip".
    let fileName: String
    
    var loopMode: LottieLoopMode = .loop
    var animationSpeed: CGFloat = 1
    var contentMode: ContentMode = .fit
    
    var body: some View {
        LottieView {
            if let cached = await LottieAnimationCache.shared.file(for: fileName) {
                return cached
            }
            let url = try await StorageManager.shared.getDownloadURL(fileName: fileName)
            let file = try await DotLottieFile.loadedFrom(url: url)
            print("Lottie animation fetched from Firebase Storage: \(fileName)")
            await LottieAnimationCache.shared.store(file, for: fileName)
            return file
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
    LottieStoragePlayer(fileName: "cade-lottie.zip")
        .frame(width: 200, height: 200)
}
