//
//  LottieTestView.swift
//  FirebasePracticeAppNBA
//
//  Created by Antonio Gargiulo on 8/8/26.
//

import SwiftUI

struct LottieTestView: View {
    var body: some View {
        ScrollView {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
                
                
                LottiePlayer(animationName: "Star rating 1")
                    .frame(width: 200, height: 200)
                
                
                LottieStoragePlayer(fileName: "cade-lottie.zip")
                LottieStoragePlayer(fileName: "porz.zip")
                LottieStoragePlayer(fileName: "sengun2.zip")
            }
            .padding()
        }
    }
}


#Preview {
    LottieTestView()
}
