//
//  StoreViewModel.swift
//  FirebasePracticeAppNBA
//
//  Created by Antonio Gargiulo on 8/8/26.
//

import Foundation

struct StoreItem: Identifiable {
    let id = UUID()
    let fileName: String
    let price: Int
}

@MainActor
final class StoreViewModel: ObservableObject {

    @Published var items: [StoreItem] = []

    // Base set of Lottie files that gets looped to build the store
    private let animationFiles: [String] = [
        "cade-lottie.zip",
        "porz.zip",
        "sengun2.zip"
    ]

    init() {
        loadItems()
    }

    func loadItems() {
        // Loops cade, porz, sengun, cade, porz, sengun
        let looped = animationFiles + animationFiles
        items = looped.map { fileName in
            StoreItem(fileName: fileName, price: Int.random(in: 500...5000))
        }
    }
}
