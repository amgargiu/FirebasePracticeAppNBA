//
//  AuthViewModel.swift
//  SwiftfulFirebase
//
//  Created by Antonio Gargiulo on 5/25/26.
//

import Foundation


@MainActor
final class SelectAuthViewModel: NSObject, ObservableObject {
    
    func signInGoogle() async throws {
        let helper = SignInGoogleHelper() // create instance
        let GIDSignInResult = try await helper.signIn()// returns custom model response w/ tokens
        // want to then pass in this model with our tokkens to our function which makes a credential for Firebase
        let authDataResult = try await AuthManager.shared.signInWithGoogle(tokens: GIDSignInResult)
        
        let user = DBUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(user: user)
    }
    
    func signInApple() async throws {
        let helper = SignInAppleHelper()
        let appleSignInResult = try await helper.startSignInWithAppleFlow()
        // pass to Firebase
        let authDataResult = try await AuthManager.shared.signInWithApple(tokens: appleSignInResult)
        
        let user = DBUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(user: user)
    }
    
    func signInAnonymous() async throws {
        let authDataResult = try await AuthManager.shared.signInAnonymously()
        
        let user = DBUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(user: user)

    }
}



