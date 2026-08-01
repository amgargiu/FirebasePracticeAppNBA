//
//  ProfileView.swift
//  SwiftfulFirebase
//
//  Created by Antonio Gargiulo on 5/25/26.
//

import SwiftUI
import PhotosUI


struct ProfileView: View {
    
    @StateObject var vm = ProfileViewModel()
    @Binding var showSignInView: Bool
    @State private var selectedItem: PhotosPickerItem? = nil
    
    @State private var url: URL? = nil
    
    let preferenceOptions: [String] = ["Sports", "Movies", "Books"]
    
    // extra func to check if a given peference string option is already in the User prefereces - returns Bool
    private func preferenceIsSelected(text: String) -> Bool {
        vm.user?.preferences?.contains(text) == true
    }
    
    var body: some View {
        List {
            if let user = vm.user {
                Text("User id: \(user.userId)")
                    .textSelection(.enabled)
                
                
                
                if let isAnonymous = user.isAnonymous {
                    Text("is Anonymous: \(isAnonymous.description)")
                }
                
                Button {
                    vm.togglePremiumStatus()
                } label: {
                    Text("User is premium: \((user.isPremium ?? false).description)")
                }
                
                // MARK: STORAGE
                
                PhotosPicker(selection: $selectedItem, photoLibrary: .shared()) {
                    Text("Select a photo")
                }
                
                
                
                
                
                Button("Load Current User") {
                    Task {
                        try? await vm.loadCurrentUser()
                    }
                }
                
                
            }
        }
        .navigationTitle(Text("Profile"))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    SettingsView(showSignInView: $showSignInView)
                } label: {
                    Image(systemName: "gear")
                        .font(.headline)
                }
                
            }
        }
        .task {
            print("Profile view appearing")
            try? await vm.loadCurrentUser()
        }
        //        .onChange(of: selectedItem) { newValue in
        //            if let newValue {
        //                vm.saveProfileImage(item: newValue)
        //            }
        
        
    }
}


#Preview {
    NavigationStack {
        ProfileView(showSignInView: .constant(false))
    }
}
