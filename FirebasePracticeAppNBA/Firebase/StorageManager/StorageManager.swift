//
//  StorageManager.swift
//  FirebasePracticeAppNBA
//
//  Created by Antonio Gargiulo on 8/8/26.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    
    static let shared = StorageManager()
    private init() { }
    
    private let storage = Storage.storage().reference()
    
    private func lottieZipsReference(fileName: String) -> StorageReference {
        storage.child("LottieZips").child(fileName)
    }
    
    func getDownloadURL(fileName: String) async throws -> URL {
        try await lottieZipsReference(fileName: fileName).downloadURL()
    }
}
