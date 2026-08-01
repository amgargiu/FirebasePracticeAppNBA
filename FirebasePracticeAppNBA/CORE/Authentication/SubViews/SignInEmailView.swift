//
//  SignInEmailView.swift
//  SwiftfulFirebase
//
//  Created by Antonio Gargiulo on 5/16/26.
//

import SwiftUI

struct SignInEmailView: View {
    
    @StateObject private var vm = SignInEmailViewModel()
    
    @Binding var showSignInView: Bool

    
    var body: some View {
        VStack {
            TextField("Email...", text: $vm.email)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(8)
            
            SecureField("Password...", text: $vm.password)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(8)
            
            Button {
                Task {
                    // Try to Sign-UP user
                    do {
                        try await vm.signUp()
                        // Success in sign up and creating user (no duplicate email found)
                        showSignInView = false // dismisses the AuthView and goes to SettingsView (RootView logic)
                        return // return from closure if success
                    } catch {
                        print(error)
                    }
                    
                    // If intial return hit - exit Task entirely - else will reach this point in code
                    
                    // Try to sign-IN an Existing User
                    do {
                        try await vm.signIn()
                        showSignInView = false // will also go back into app (represented by SettingView) once sign in
                        return
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Sign in")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .cornerRadius(10)
            }
            
            Spacer()

        }
        .padding()
        .navigationTitle(Text("Sign In w Email"))
    }
}

#Preview {
    NavigationStack {
        SignInEmailView(showSignInView: .constant(false))
    }
}
