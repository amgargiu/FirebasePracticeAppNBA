//
//  PickManager.swift
//  FirebasePracticeAppNBA
//
//  Created by Antonio Gargiulo on 8/2/26.
//

import Foundation
import FirebaseFirestore

final class PickManager {
    
    static let shared = PickManager()
    private init() { }
    
    private let picksCollection = Firestore.firestore().collection("picks")
    
    // get path to individual doc
    private func pickDocument(pickId: String) -> DocumentReference {
        picksCollection.document(pickId)
    }
    
    // mark as async since going to server
    func uploadPick(pick: PickModel) async throws {
        try pickDocument(pickId: pick.id).setData(from: pick, merge: false)
    }
    
    // get 1 document - decode
    func getPick(pickId: String) async throws -> PickModel {
        try await pickDocument(pickId: pickId).getDocument(as: PickModel.self)
    }
    
    // upload an entire array — used when confirming a full review batch at once
    func uploadPicks(picks: [PickModel]) async throws {
        for pick in picks {
            try await uploadPick(pick: pick)
        }
    }
    
    // MARK: - Fetch All Picks For A User
    
    private func getUserPicksQuery(userId: String) -> Query {
        picksCollection.whereField("userId", isEqualTo: userId)
    }
    
    func getAllPicks(userId: String) async throws -> [PickModel] {
        try await getUserPicksQuery(userId: userId).getDocuments2(as: PickModel.self)
    }
}
