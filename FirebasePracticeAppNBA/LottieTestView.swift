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
                
                LottiePlayer(animationName: "cade-lottie")
                    .frame(width: 200, height: 200)
                
                LottiePlayer(animationName: "Star rating 1")
                    .frame(width: 200, height: 200)
                
                LottiePlayer(animationName: "porzingis")
                    .frame(width: 200, height: 200)
                
                LottiePlayer(animationName: "sengun2")
                    .frame(width: 200, height: 200)
                
                LottiePlayer(animationName: "sengun")
                    .frame(width: 200, height: 200)
                
                LottiePlayer(animationName: "porz")
                    .frame(width: 200, height: 200)
            }
            .padding()
        }
    }
}


#Preview {
    LottieTestView()
}
