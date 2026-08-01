//
//  TabBarView.swift
//  SwiftfulFirebase
//
//  Created by Antonio Gargiulo on 5/31/26.
//

import SwiftUI

struct TabBarView: View {
    
    
    @Binding var showSignInView: Bool
    
    var body: some View {
        
        
        TabView {
            
            NavigationStack {
                Text("Home")
            }
            .tabItem {
                Label("Products", systemImage: "cart")
            }
            
            NavigationStack {
                Text("Other")
            }
            .tabItem {
                Label("Products", systemImage: "star.fill")
            }
            
            NavigationStack {
                ProfileView(showSignInView: $showSignInView)
            }
            .tabItem {
                Label("Profile", systemImage: "person")
            }
        }
    }
}

#Preview {
    TabBarView(showSignInView: .constant( false))
}
