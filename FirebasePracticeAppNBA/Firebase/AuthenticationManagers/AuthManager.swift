//
//  AuthManager.swift
//  SwiftfulFirebase
//
//  Created by Antonio Gargiulo on 5/16/26.
//

import Foundation
import FirebaseAuth


// Firebase SDK

struct AuthDataResultModel {
    let uid: String
    let email: String? //optional since if sign in diff way we might not get email
    let displayName: String?
    let photoUrl: String? // may not have (comes in as URL type now) - keeping these as simple data type for database
    let isAnonymous: Bool?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.displayName = user.displayName
        self.photoUrl = user.photoURL?.absoluteString
        self.isAnonymous = user.isAnonymous
    }
    
}

enum AuthProviderOption: String {
    case email = "password"
    case google = "google.com"
    case apple = "apple.com"
}


// MARK: Generic Auth Methods

final class AuthManager {
    
    static let shared = AuthManager()
    
    private init() {}
    
    // locally check if user exists - not async which would = call to server
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        return AuthDataResultModel(user: user)
    }
    
    func signOut() throws {
        try Auth.auth().signOut() // not async - just throws
    }
    
    func delete() async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        try await user.delete()
    }
    
    
    
    // google.com
    // password

    func getProviders() throws -> [AuthProviderOption] {
        guard let providerData = Auth.auth().currentUser?.providerData else {
            throw URLError(.badServerResponse)
        }
        
        
        var providers: [AuthProviderOption] = []
        for provider in providerData {
            if let option = AuthProviderOption(rawValue: provider.providerID) {
                providers.append(option)
            } else {
                assertionFailure("Provider option not found \(provider.providerID)")
            }
        }
        print(providers)
        return providers
    }
    
    
    
}


// MARK: SIGN IN EMAIL & PASS Functions

extension AuthManager {
    
    
    // Create a user with ID - store locally
    @discardableResult
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    // Sign in Exisitng User
    @discardableResult
    func signInUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    
    func resetPassword(email: String) async throws { // if doesn't throw error it is successful
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func updatePassword(password: String) async throws { // updating
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        try await user.updatePassword(to: password)
    }
    
    func updateEmail(email: String) async throws { // updating
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        try await user.updateEmail(to: email)
    }
    
}



// MARK: SIGN IN SSO - Google & APPLE Functions

extension AuthManager {
    
    
    // GOOGLE - sign in w/ Firebase for Auth - but provide google credential
    
    @discardableResult
    func signInWithGoogle(tokens: GoogleSignInResultModel) async throws -> AuthDataResultModel {
        // Get both those tokens and create this credential (used instead of Email / passowrd) - creatign credentil is FB method
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        // Firebase method  - just sign in with credential
        return try await signInWithCredential(credential: credential)
        
    }
    
    
    // APPLE
    
    @discardableResult
    func signInWithApple(tokens: SignInWithAppleResultModel) async throws -> AuthDataResultModel {
        // Get both those tokens and create this credential (used instead of Email / passowrd) - creating  credentil is FB method
        
        // Slightly different from 2023
        let credential = OAuthProvider.credential(
            providerID: .apple,                      // 1. Label changed to 'providerID' (no 'with') and takes the enum
            idToken: tokens.token,                   // 2. Your token string
            rawNonce: tokens.nonce,                  // 3. Your nonce string
            accessToken: nil                         // 4. Modern Firebase expects this parameter (you can pass nil)
        )
        
        // Firebase method  - just sign in with credential
        return try await signInWithCredential(credential: credential)
        
    }
    
    
    // Extracted Sign in w/ Credential - use for both google and apple
    
    func signInWithCredential(credential: AuthCredential) async throws -> AuthDataResultModel {
        // We are creating our local signIn function which within it uses the Firebase Auth function signIn
        let authDataResult = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
}



// MARK: SIGN IN ANONYMOUS

extension AuthManager {
    
    @discardableResult
    func signInAnonymously() async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signInAnonymously()
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    
    func linkEmail(email: String, password: String) async throws -> AuthDataResultModel {
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        return try await linkCredential(credential: credential)
    }
    
    
    func linkApple(tokens: SignInWithAppleResultModel) async throws -> AuthDataResultModel {
        // Slight different from 2023
        let credential = OAuthProvider.credential(
            providerID: .apple,                      // 1. Label changed to 'providerID' (no 'with') and takes the enum
            idToken: tokens.token,                   // 2. Your token string
            rawNonce: tokens.nonce,                  // 3. Your nonce string
            accessToken: nil                         // 4. Modern Firebase expects this parameter (you can pass nil)
        )
        return try await linkCredential(credential: credential)
    }
    
    
    func linkGoogle(tokens: GoogleSignInResultModel) async throws -> AuthDataResultModel {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        return try await linkCredential(credential: credential)
        
    }
    
    
    private func linkCredential(credential: AuthCredential) async throws -> AuthDataResultModel {
        // in order to link we need to get the user that is already authenticated
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        // linek the user with credential
        let authDataResult = try await user.link(with: credential)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    
    
}
