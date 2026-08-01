//
//  UserManager.swift
//  FirebasePracticeAppNBA
//
//  Created by Antonio Gargiulo on 7/29/26.
//

import Foundation
import FirebaseFirestore

final class UserManager {
    
    static let shared = UserManager()
    private init() {}
    
    // Core collection reference
    private let userCollection = Firestore.firestore().collection("users")
    
    // Helper document reference
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    // MARK: - Core Database Functions
    
    /// Creates a new user document in Firestore if one does not already exist.
    func createNewUser(user: DBUser) async throws {
        let docRef = userDocument(userId: user.userId)
        let snapshot = try await docRef.getDocument()
        
        guard !snapshot.exists else {
            // User already has a document — don't overwrite it
            print("User already exists in Firestore.")
            return
        }
        
        try docRef.setData(from: user, merge: false)
    }
    
    /// Fetches the DBUser document from Firestore for the given userId.
    func getUser(userId: String) async throws -> DBUser {
        try await userDocument(userId: userId).getDocument(as: DBUser.self)
    }
    
    /// Updates specific fields on the user document using DBUser.CodingKeys for type safety.
    func updateUserPremiumStatus(userId: String, isPremium: Bool) async throws {
        let data: [String: Any] = [
            DBUser.CodingKeys.isPremium.rawValue: isPremium
        ]
        try await userDocument(userId: userId).updateData(data)
    }
    
    /// Deletes the user document from Firestore (useful for account deletion flows).
    func deleteUser(userId: String) async throws {
        try await userDocument(userId: userId).delete()
    }
}
