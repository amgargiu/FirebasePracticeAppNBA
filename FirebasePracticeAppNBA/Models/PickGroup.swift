//
//  PickGroupModel.swift
//  FirebasePracticeAppNBA
//
//  Created by Antonio Gargiulo on 8/4/26.
//

import Foundation

/// A single pack-opening session's worth of picks, grouped by packOpeningId.
struct PickGroup: Identifiable {
    let id: String            // = packOpeningId
    let pack: PackModel
    let picks: [PickModel]
    let dateCreated: Date?    // from the earliest pick in the group, for sorting
}
