//
//  SettingsViewModel.swift
//  SwiftfulFirebase
//
//  Created by Antonio Gargiulo on 5/25/26.
//

import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
    
    @Published var authProvider : [AuthProviderOption] = []
    @Published var authUser : AuthDataResultModel? = nil

    
    func loadAuthProviders() {
        if let providers = try?  AuthManager.shared.getProviders() {
            authProvider = providers
        }
    }
    
    func loadAuthUser() {
        self.authUser = try? AuthManager.shared.getAuthenticatedUser()
    }
    
    func signOut() throws {
        try AuthManager.shared.signOut() // remember this sign out func is not async
    }
    
    func deleteAccount() async throws {
        // 1. Get current authenticated user's ID
        let authUser = try AuthManager.shared.getAuthenticatedUser()
        
        // 2. UserMnanager - Delete Firestore document FIRST while still authenticated
        try await UserManager.shared.deleteUser(userId: authUser.uid)
        
        // 3. AuthManager - Delete Firebase Auth user SECOND
        try await AuthManager.shared.delete()
    }
    
    
    func resetPassword() async throws {
        let authUser = try AuthManager.shared.getAuthenticatedUser()
        guard let email = authUser.email else {
            throw URLError(.badServerResponse)
        }
        // have user and their email at this point
        try await AuthManager.shared.resetPassword(email: email)
    }
    
    func updatePassword() async throws {
        let password = "hello123"
        try await AuthManager.shared.updatePassword(password: password)
    }
    
    func updateEmail() async throws {
        let email = "hello3@example.com"
        try await AuthManager.shared.updateEmail(email:  email)
    }
    
    
    // ------------------- LINK anonymous
    
    
    func linkGoogleAccount() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        let authDataResult = try await AuthManager.shared.linkGoogle(tokens: tokens)
        self.authUser = authDataResult
    }
    
    func linkAppleAccount() async throws {
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        let authDataResult = try await AuthManager.shared.linkApple(tokens: tokens)
        self.authUser = authDataResult
    }
    
    func linkEmailAccount() async throws {
        let email = "hello123@gmail.com"
        let password = "1789"
        let authDataResult = try await AuthManager.shared.linkEmail(email: email, password: password)
        self.authUser = authDataResult
    }

    
    
}
