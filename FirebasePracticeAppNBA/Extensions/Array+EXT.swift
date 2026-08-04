//
//  ArrayExtension.swift
//  FirebasePracticeAppNBA
//
//  Created by Antonio Gargiulo on 8/4/26.
//

import Foundation

extension Array {
    /// Splits the array into subarrays of at most `size` elements each.
    /// Used to batch Firestore `in` queries, which cap at 30 values per query.
    func chunked(into size: Int) -> [[Element]] {
        guard size > 0 else { return [self] }
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}
