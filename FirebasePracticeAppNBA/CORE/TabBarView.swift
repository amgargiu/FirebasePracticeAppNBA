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
                HomeView(showSignInView: $showSignInView)
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            
            NavigationStack {
                MyPicksView()
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
                Text("Tourneys")
            }
            .tabItem {
                Label("Tourneys", systemImage: "trophy.fill")
            }
            
            NavigationStack {
                StoreView()
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
