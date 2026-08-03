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
                HomeView()
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            
            NavigationStack {
                Text("My Picks")
            }
            .tabItem {
                Label("My Picks", systemImage: "checkmark.circle.fill")
            }
            
            NavigationStack {
                Text("Refer a Friend")
            }
            .tabItem {
                Label("Refer a Friend", systemImage: "person.2.fill")
            }
            
            NavigationStack {
                Text("Tournaments")
            }
            .tabItem {
                Label("Tournaments", systemImage: "trophy.fill")
            }
            
            NavigationStack {
                Text("Shop")
            }
            .tabItem {
                Label("Shop", systemImage: "bag.fill")
            }
        }
    }
}

#Preview {
    TabBarView(showSignInView: .constant(false))
}
