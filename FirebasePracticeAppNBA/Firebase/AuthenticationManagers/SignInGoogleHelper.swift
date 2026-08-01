//
//  SignInGoogleHelper.swift
//  SwiftfulFirebase
//
//  Created by Antonio Gargiulo on 5/21/26.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift


// Google SDK not FB

struct GoogleSignInResultModel {
    let idToken: String
    let accessToken: String
    let name: String?
    let email: String?
}


final class SignInGoogleHelper {
    
    @MainActor
    func signIn() async throws -> GoogleSignInResultModel {
        guard let topVC = Utilities.shared.topViewController() else {
            throw URLError(.badServerResponse)
        }
        
        // Google method
        let gidSignedInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        
        // Access GIDSignInResult proprties
        guard let idToken: String = gidSignedInResult.user.idToken?.tokenString else { throw URLError(.badServerResponse)}
        let accessToken: String  = gidSignedInResult.user.accessToken.tokenString // already a string
                
        // Extra user profile info
        let name = gidSignedInResult.user.profile?.name
        let email = gidSignedInResult.user.profile?.email
        
        // use credential to sign into Firebase
        let tokens = GoogleSignInResultModel(idToken: idToken, accessToken: accessToken, name: name, email: email)
        return tokens
    }
    
   
    
}
