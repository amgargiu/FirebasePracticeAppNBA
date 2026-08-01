//
//  AuthView.swift
//  SwiftfulFirebase
//
//  Created by Antonio Gargiulo on 5/16/26.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

//
//
//struct SelectAuthView: View {
//    
//    @StateObject var vm = SelectAuthViewModel()
//    
//    @Binding var showSignInView: Bool
//    
//    var body: some View {
//        VStack {
//            
//            
//            Button {
//                Task {
//                    do {
//                        // Trigger your viewmodel function here
//                        try await vm.signInAnonymous()
//                        showSignInView = false
//                    } catch {
//                        print("Error signing in with Apple: \(error)")
//                    }
//                }
//            } label: {
//                Text("Sign in Anonymously")
//                    .font(.headline)
//                    .foregroundStyle(.white)
//                    .frame(height: 55)
//                    .frame(maxWidth: .infinity)
//                    .background(.orange)
//                    .cornerRadius(10)
//            }
//
//            
//            NavigationLink {
//                SignInEmailView(showSignInView: $showSignInView)
//            } label: {
//                Text("Sign in w/ Email")
//                    .font(.headline)
//                    .foregroundStyle(.white)
//                    .frame(height: 55)
//                    .frame(maxWidth: .infinity)
//                    .background(.blue)
//                    .cornerRadius(10)
//            }
//            
//            GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide, state: .normal)) {
//                //
//                Task {
//                    do {
//                        try await vm.signInGoogle()
//                        showSignInView = false
//                    } catch {
//                        print(error)
//                    }
//                }
//            }
//            
//            
//            //-------------------------------------------------------------------------------------------
//
//            
//            //-------------------------------------------------------------------------------------------
//            
//            Text("UIKit below")
//            
//            Button {
//                // This is the custom closure bracket your instructor wanted!
//                Task {
//                    do {
//                        // Trigger your viewmodel function here
//                        try await vm.signInApple()
//                        showSignInView = false
//                    } catch {
//                        print("Error signing in with Apple: \(error)")
//                    }
//                }
//            } label: {
//                // Render the UIKit button visually but disable its native tap handler
//                SignInWithAppleButtonViewRepresentable(type: .default, style: .black)
//                    .allowsHitTesting(false)
//            }
//            .frame(height: 55)
//
//            
//            
//            Spacer()
//        }
//        .padding()
//        .navigationTitle(Text("Sign In"))
//    }
//}
//
//
//
//import SwiftUI
//import GoogleSignInSwift

struct SelectAuthView: View {
    
    @StateObject var vm = SelectAuthViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            
            Spacer()
            
            // 1. Main Action: Sign in with Email
            NavigationLink {
                SignInEmailView(showSignInView: $showSignInView)
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: "envelope.fill")
                        .font(.headline)
                    Text("Sign in with Email")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                .foregroundStyle(.white)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(.blue)
                .cornerRadius(16)
                .shadow(color: .blue.opacity(0.25), radius: 8, x: 0, y: 4)
            }
            
            // Divider
            HStack(spacing: 16) {
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(Color.gray.opacity(0.3))
                
                Text("or connect with")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(Color.gray.opacity(0.3))
            }
            .padding(.vertical, 8)
            
            // 2. Horizontal Stack of 3 Circular Buttons
            HStack(spacing: 24) {
                
                // --- Apple Sign-In Circle ---
                Button {
                    Task {
                        do {
                            try await vm.signInApple()
                            showSignInView = false
                        } catch {
                            print("Error signing in with Apple: \(error)")
                        }
                    }
                } label: {
                    CircleIconButton(iconName: "apple.logo", isSystemImage: true, color: .primary)
                }
                
                // --- Google Sign-In Circle ---
                Button {
                    Task {
                        do {
                            try await vm.signInGoogle()
                            showSignInView = false
                        } catch {
                            print("Error signing in with Google: \(error)")
                        }
                    }
                } label: {
                    CircleIconButton(iconName: "SignInGoogleDot", isSystemImage: false, color: .clear)
                }
                
                // --- Anonymous Sign-In Circle ---
                Button {
                    Task {
                        do {
                            try await vm.signInAnonymous()
                            showSignInView = false
                        } catch {
                            print("Error signing in anonymously: \(error)")
                        }
                    }
                } label: {
                    CircleIconButton(iconName: "person.fill", isSystemImage: true, color: .secondary)
                }
            }
            
            Spacer()
        }
        .padding(24)
        .navigationTitle("Sign In")
    }
}

// MARK: - Circular Icon Component
struct CircleIconButton: View {
    let iconName: String
    var isSystemImage: Bool = true
    let color: Color
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(UIColor.secondarySystemBackground))
                .frame(width: 60, height: 60)
                .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
            
            if isSystemImage {
                Image(systemName: iconName)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(color)
            } else {
                Image(iconName) // Pulls "SignInGoogleDot" from Assets
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
            }
        }
    }
}


#Preview {
    NavigationStack {
        SelectAuthView(showSignInView: .constant(false))
    }
}
