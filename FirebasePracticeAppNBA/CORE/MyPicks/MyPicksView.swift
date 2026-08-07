//
//  MyPicksView.swift
//  FirebasePracticeAppNBA
//
//  Created by Antonio Gargiulo on 8/4/26.
//

import SwiftUI

struct MyPicksView: View {
    
    @StateObject private var vm = MyPicksViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                if vm.isLoading && vm.pickGroups.isEmpty {
                    ProgressView()
                        .padding(.top, 60)
                } else if vm.pickGroups.isEmpty {
                    Text("No picks yet — open a pack to get started.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.top, 60)
                } else {
                    ForEach(Array(vm.pickGroups.enumerated()), id: \.element.id) { index, group in
                        PickGroupView(
                            group: group,
                            playersById: vm.playersById,
                            isInitiallyExpanded: index == 0
                        )
                    }
                }
            }
            .padding()
        }
        .navigationTitle("My Picks")
        .task {
            await vm.loadPicks()
        }
        .alert("Something went wrong", isPresented: .constant(vm.loadError != nil), actions: {
            Button("OK") {
                vm.loadError = nil
            }
        }, message: {
            Text(vm.loadError ?? "")
        })
    }
}

#Preview {
    NavigationStack {
        MyPicksView()
    }
}
