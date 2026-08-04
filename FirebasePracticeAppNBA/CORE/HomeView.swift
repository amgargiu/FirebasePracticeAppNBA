//
//  HomeView.swift
//  FirebasePracticeAppNBA
//
//  Created by Antonio Gargiulo on 8/3/26.
//

import SwiftUI

struct HomeView: View {
    
    @Binding var showSignInView: Bool
    
    @State private var selectedPack: PackModel? = nil
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                header
                packsSection
                shopButton
                creatorSessionSection
                Spacer(minLength: 40)
            }
            .padding()
        }
        .navigationTitle("Home")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    ProfileView(showSignInView: $showSignInView)
                } label: {
                    Image(systemName: "person.circle")
                        .font(.title2)
                }
            }
        }
        .fullScreenCover(item: $selectedPack) { pack in
            PackOpeningView(pack: pack)
        }
    }
    
    // MARK: - Header
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Welcome Back")
                .font(.largeTitle.bold())
            Text("Here's what's happening today")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    
    // MARK: - Packs
    
    private var packsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("NBA Packs")
                .font(.title2.bold())
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(PackModel.allPacks) { pack in
                        Image(pack.imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 160, height: 220)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white.opacity(0.15), lineWidth: 1)
                            )
                            .onTapGesture {
                                selectedPack = pack
                            }
                    }
                }
                .padding(.horizontal, 2)
                .padding(.vertical, 4)
            }
        }
    }
    
    // MARK: - Shop Button
    
    private var shopButton: some View {
        Button(action: {
            // TODO: navigate to shop
        }) {
            Text("Go to Shop")
                .font(.headline.bold())
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(14)
        }
    }
    
    // MARK: - Creator Sessions (placeholder content)
    
    private var creatorSessionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Creator Sessions")
                .font(.title2.bold())
            
            VStack(alignment: .leading, spacing: 8) {
                Text("🔥 Live Now: @HoopsGuru's Playoff Picks")
                    .font(.subheadline.bold())
                Text("Join the session and compete with the community.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Button(action: {
                    // TODO: join creator session
                }) {
                    Text("Join a Creator Session")
                        .font(.subheadline.bold())
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.purple)
                        .cornerRadius(12)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.secondarySystemBackground))
            )
        }
    }
}

#Preview {
    NavigationStack {
        HomeView(showSignInView: .constant(false))
    }
}
