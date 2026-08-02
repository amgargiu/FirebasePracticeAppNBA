//
//  SettingsView.swift
//  SwiftfulFirebase
//
//  Created by Antonio Gargiulo on 5/17/26.
//

import SwiftUI



struct SettingsView: View {
    
    @StateObject private var vm = SettingsViewModel()
    @Binding var showSignInView : Bool
    
    var body: some View {
        List {
            Button("Log Out") {
                Task{
                    do {
                        try vm.signOut()
                        showSignInView = true
                    } catch {
                        print("error: \(error)")
                    }
                }
            }
            
            
            Button(role: .destructive) {
                Task{
                    do {
                        try await vm.deleteAccount()
                        showSignInView = true
                    } catch {
                        print("error: \(error)")
                    }
                }
            } label: {
                Text("Delete Account")
            }

            
            if vm.authProvider.contains(.email) {
                emailSection
            }
            
            if vm.authUser?.isAnonymous == true {
                anonymousSection
            }
            
            
            
        }
        .onAppear {
            vm.loadAuthProviders()
            vm.loadAuthUser()
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack {
        SettingsView(showSignInView: .constant(false))
    }
}



extension SettingsView {
    
    private var emailSection: some View {
        Section {
            Button("Reset password") {
                Task{
                    do {
                        try await vm.resetPassword()
                        print("password was reset")
                    } catch {
                        print("error: \(error)")
                    }
                }
            }
            
            Button("Update password") {
                Task{
                    do {
                        try await vm.updatePassword()
                        print("password was updated")
                    } catch {
                        print("error: \(error)")
                    }
                }
            }
            
            
            Button("Update email") {
                Task{
                    do {
                        try await vm.updateEmail()
                        print("email was updated")
                    } catch {
                        print("error: \(error)")
                    }
                }
            }
        } header: {
            Text("Email Functions")
        }
    }
    
    private var anonymousSection: some View {
        
        Section {
            Button("Link Google acct") {
                Task{
                    do {
                        try await vm.linkGoogleAccount()
                        print("google was linked")
                    } catch {
                        print("error: \(error)")
                    }
                }
            }
            
            Button("Link Apple acct") {
                Task{
                    do {
                        try await vm.linkAppleAccount()
                        print("apple was linked")
                    } catch {
                        print("error: \(error)")
                    }
                }
            }
            
            
            Button("Link Email account") {
                Task{
                    do {
                        try await vm.linkEmailAccount()
                        print("email was linked")
                    } catch {
                        print("error: \(error)")
                    }
                }
            }
        } header: {
            Text("Link Account")
        }
    }

}
