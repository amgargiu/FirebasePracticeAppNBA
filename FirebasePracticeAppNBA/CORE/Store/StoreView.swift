//
//  StoreView.swift
//  FirebasePracticeAppNBA
//
//  Created by Antonio Gargiulo on 8/8/26.
//

import SwiftUI

struct StoreView: View {

    @StateObject private var viewModel = StoreViewModel()
    @State private var selectedItem: StoreItem?

    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // NBA logo header
                AsyncImage(url: URL(string: "https://static.vecteezy.com/system/resources/thumbnails/015/863/585/small/nba-logo-on-transparent-background-free-vector.jpg")) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(height: 60)
                    case .failure:
                        Image(systemName: "basketball.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 50)
                            .foregroundStyle(.orange)
                    case .empty:
                        ProgressView()
                            .frame(height: 60)
                    @unknown default:
                        EmptyView()
                    }
                }
                .padding(.top, 8)

                Text("Store")
                    .font(.largeTitle.bold())

                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.items) { item in
                        StoreItemCard(item: item)
                            .onTapGesture {
                                selectedItem = item
                            }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 24)
        }
        .fullScreenCover(item: $selectedItem) { item in
            ExpandedStoreItemView(item: item) {
                selectedItem = nil
            }
            .presentationBackground(.clear)
        }
    }
}



#Preview {
    StoreView()
}
