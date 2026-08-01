//
//  ProfileViewModel.swift
//  SwiftfulFirebase
//
//  Created by Antonio Gargiulo on 7/12/26.
//

import Foundation
import SwiftUI
import PhotosUI


@MainActor
final class ProfileViewModel: ObservableObject {
    
    @Published private(set) var user: DBUser? = nil
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
    func togglePremiumStatus() {
        guard let user else { return }
        let currentValue = user.isPremium ?? false
        Task {
            try await UserManager.shared.updateUserPremiumStatus(userId: user.userId, isPremium: !currentValue)
            // re-fetch
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }
    
}
