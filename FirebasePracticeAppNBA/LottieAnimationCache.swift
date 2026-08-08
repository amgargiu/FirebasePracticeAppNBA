//
//  LottieAnimationCache.swift
//  FirebasePracticeAppNBA
//
//  Created by Antonio Gargiulo on 8/8/26.
//

import Foundation
import Lottie

/// Shared, in-memory cache of already-loaded DotLottieFile animations,
/// keyed by their Firebase Storage filename (e.g. "porz.zip").
///
/// DotLottieFile.loadedFrom(url:) already handles fetching + parsing the
/// zip internally — there's no manual download/unzip step to cache around.
/// The expensive, repeatable work is (1) resolving the download URL via
/// StorageManager and (2) the fetch+parse itself. Caching the resulting
/// DotLottieFile skips both on a cache hit.
///
/// Backed by NSCache rather than a plain dictionary so entries get evicted
/// automatically — both under system memory pressure, and once the
/// configured limits below are exceeded — instead of growing unbounded
/// for the life of the app.
actor LottieAnimationCache {

    static let shared = LottieAnimationCache()

    private init() {
        // Hard cap on number of cached animations, regardless of size.
        // This is the more trustworthy limit — it's exact, not estimated.
        cache.countLimit = 30

        // Soft cap in "cost" units, summed across cached items. NSCache has
        // no way to introspect a DotLottieFile's real memory footprint, so
        // this relies on the estimatedCost value below rather than an exact
        // byte count. Treat this as a rough safety net, not precise budgeting.
        cache.totalCostLimit = 50 * 1024 * 1024 // ~50MB
    }

    private let cache = NSCache<NSString, DotLottieFile>()

    /// Placeholder per-item cost since we don't have real size data for a
    /// parsed DotLottieFile. Adjust this if you're able to measure actual
    /// memory usage per animation later — countLimit is doing the real
    /// work until then.
    private let estimatedCostPerItem = 1_000_000 // ~1MB guess per animation

    func file(for fileName: String) -> DotLottieFile? {
        let cached = cache.object(forKey: fileName as NSString)
        if cached != nil {
            print("Lottie animation loaded from cache: \(fileName)")
        }
        return cached
    }

    func store(_ file: DotLottieFile, for fileName: String) {
        cache.setObject(file, forKey: fileName as NSString, cost: estimatedCostPerItem)
        print("Lottie animation saved to cache: \(fileName)")
    }

    /// Optional escape hatch if you ever need to force a fresh reload.
    func evict(fileName: String) {
        cache.removeObject(forKey: fileName as NSString)
    }

    func clearAll() {
        cache.removeAllObjects()
    }
}
