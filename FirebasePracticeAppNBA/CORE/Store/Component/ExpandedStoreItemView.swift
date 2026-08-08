//
//  ExpandedStoreItemView.swift
//  FirebasePracticeAppNBA
//
//  Created by Antonio Gargiulo on 8/8/26.
//

import SwiftUI

struct ExpandedStoreItemView: View {
    let item: StoreItem
    var onDismiss: () -> Void

    var body: some View {
        ZStack {
            // Dimmed backdrop — tap anywhere out here to dismiss
            Color.white.opacity(0.01)
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss()
                }

            // The expanded card itself — tapping inside does NOT dismiss
            VStack(spacing: 24) {
                HStack {
                    Spacer()
                    Button {
                        onDismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.secondary)
                    }
                }

                LottieStoragePlayer(fileName: item.fileName)
                    .frame(width: 260, height: 260)

                HStack(spacing: 10) {
                    Image(systemName: "star.circle")
                        .font(.title2)
                        .foregroundStyle(.green)
                    Text("\(item.price)")
                        .font(.title.bold())
                        .foregroundStyle(.primary)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 10)
                .background(
                    Capsule()
                        .fill(Color(.secondarySystemBackground))
                )
            }
            .padding(24)
            .frame(width: 320)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.2), radius: 16, x: 0, y: 8)
            )
            // Swallow taps on the card so they don't fall through to the backdrop
            .onTapGesture { }
        }
    }
}

#Preview {
    ExpandedStoreItemView(
        item: StoreItem(fileName: "porz.zip", price: 100),
        onDismiss: {}
    )
}
