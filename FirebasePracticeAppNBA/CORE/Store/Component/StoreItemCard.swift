//
//  StoreCardView.swift
//  FirebasePracticeAppNBA
//
//  Created by Antonio Gargiulo on 8/8/26.
//

import SwiftUI

struct StoreItemCard: View {
    let item: StoreItem

    var body: some View {
        VStack(spacing: 12) {
            LottieStoragePlayer(fileName: item.fileName)
                .frame(width: 140, height: 140)

            // Price capsule with star label
            HStack(spacing: 6) {
                Image(systemName: "star.circle")
                    .foregroundStyle(.green)
                Text("\(item.price)")
                    .font(.subheadline.bold())
                    .foregroundStyle(.primary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(Color(.secondarySystemBackground))
            )
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
        )
    }
}


#Preview {
    StoreItemCard(item: StoreItem.init(fileName: "porz.zip", price: 100))
}
