//
//  PropCardsView.swift
//  FirebasePracticeAppNBA
//
//  Created by Antonio Gargiulo on 8/1/26.
//

import SwiftUI

struct PropCardsView2: View {
    
    @StateObject private var vm = PropCardsViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(vm.propCards) { propCard in
                    PropCardView(propCard: propCard)
                }
            }
            .padding()
        }
        .task {
            vm.loadPropCards()
        }
    }
}

#Preview {
    PropCardsView2()
}
