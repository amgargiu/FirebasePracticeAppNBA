//
//  PlayersView.swift
//  FirebasePracticeAppNBA
//
//  Created by Antonio Gargiulo on 8/1/26.
//

import SwiftUI

struct PlayersView: View {
    
    @StateObject private var vm = PlayersViewModel()
    
    var body: some View {
        List {
            ForEach(vm.players) { player in
                Text(player.displayName)
                    .onAppear {
                        // Trigger pagination when the last item actually renders
                        if player == vm.players.last {
                            vm.getPlayers()
                        }
                    }
            }
            
            // Show loading indicator at the bottom if more data can be fetched
            ProgressView()
                .frame(maxWidth: .infinity, alignment: .center)
                .listRowBackground(Color.clear)
        }
        .listStyle(.grouped)
        .padding()
        .onAppear {
            vm.getPlayers()
//            vm.getPlayersAndUploadToFB()
        }
        .navigationTitle("Players")

    }
}

#Preview {
    NavigationStack {
        PlayersView()
    }
}

