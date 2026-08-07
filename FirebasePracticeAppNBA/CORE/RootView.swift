//
//  FirstScreenView.swift
//  FirebasePracticeAppNBA
//
//  Created by Antonio Gargiulo on 7/27/26.
//

import SwiftUI

struct RootView: View {
    
    @State private var showSignInView: Bool = false
    
    var body: some View {
        
        ZStack {
            if !showSignInView {
                TabBarView(showSignInView: $showSignInView)
            }
        }
        .onAppear {
            print("running on appear func")
            let authUser = try? AuthManager.shared.getAuthenticatedUser() // not in VM here for some reason
            self.showSignInView = authUser == nil ? true : false // dont really need ternary op here
            print("showSignInView: \(self.showSignInView)")
            print("auth user: \(authUser)")
            try? AuthManager.shared.getProviders()
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                SelectAuthView(showSignInView: $showSignInView)
            }
        }
    }
}

#Preview {
    RootView()
}
