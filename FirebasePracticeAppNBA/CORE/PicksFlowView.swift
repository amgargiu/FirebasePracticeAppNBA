//
//  PicksFlowView.swift
//  FirebasePracticeAppNBA
//
//  Created by Antonio Gargiulo on 8/3/26.
//

import SwiftUI

struct PicksFlowView: View {
    
    let pack: PackModel
    @StateObject var vm: PropCardsViewModel
    
    // The live, shrinking navigable stack. Deciding removes a card for good;
    // skipping rotates it to the back so it resurfaces later.
    @State private var queue: [PropCard] = []
    
    init(pack: PackModel) {
        self.pack = pack
        _vm = StateObject(wrappedValue: PropCardsViewModel(packId: pack.id))
    }
    
    var body: some View {
        ZStack {
            PackBackground()
            
            if vm.propCards.isEmpty {
                ProgressView()
            } else if queue.isEmpty {
                ReviewPicksView(vm: vm)
            } else {
                PropCardsStackView(vm: vm, queue: $queue)
            }
        }
        .task {
            vm.loadPropCards()
        }
        .onReceive(vm.$propCards) { newCards in
            // Seed the queue once, the first time cards arrive
            if queue.isEmpty && !newCards.isEmpty {
                queue = newCards
            }
        }
    }
}

#Preview {
    PicksFlowView(pack: PackModel.allPacks[0])
}
