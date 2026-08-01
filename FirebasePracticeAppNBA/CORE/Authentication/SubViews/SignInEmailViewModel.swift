//
//  SignInEmailViewModel.swift
//  SwiftfulFirebase
//
//  Created by Antonio Gargiulo on 5/25/26.
//

import Foundation

@MainActor
final class SignInEmailViewModel : ObservableObject {
    
    @Published var email : String = ""
    @Published var password : String = ""
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("Please fill in all the fields")
            return
        }
        
        let authDataResult = try await AuthManager.shared.createUser(email: email, password: password)
        
        let user = DBUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(user: user)
    }
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("Please fill in all the fields")
            return
        }
        
        let returnedUserData = try await AuthManager.shared.signInUser(email: email, password: password)
    }
    
}
