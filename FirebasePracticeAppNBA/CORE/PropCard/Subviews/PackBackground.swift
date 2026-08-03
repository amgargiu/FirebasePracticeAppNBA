//
//  PackBackground.swift
//  FirebasePracticeAppNBA
//
//  Created by Antonio Gargiulo on 8/3/26.
//

import SwiftUI

/// Shared animated background — light grey/white base with large, blurred
/// "energy" blobs in continuous wave-like motion via TimelineView, rather
/// than discrete jump-and-settle repositioning. Used both by the pack-opening
/// sequence and PropCardsView itself, so the transition between the two feels
/// like one continuous scene rather than a hard cut.
struct PackBackground: View {
    
    private struct Blob {
        let baseX: CGFloat       // relative position, 0...1
        let baseY: CGFloat
        let amplitudeX: CGFloat  // how far it wanders on each axis
        let amplitudeY: CGFloat
        let speed: Double        // wave speed, radians per second
        let phase: Double        // offsets each blob so they don't move in sync
        let size: CGFloat
        let color: Color
    }
    
    @State private var blobs: [Blob] = []
    
    private let blobCount = 6
    
    var body: some View {
        GeometryReader { geo in
            TimelineView(.animation) { context in
                ZStack {
                    LinearGradient(
                        colors: [Color(white: 0.85), Color.white],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    
                    ForEach(blobs.indices, id: \.self) { index in
                        blobView(for: blobs[index], in: geo.size, time: context.date.timeIntervalSinceReferenceDate)
                    }
                }
            }
        }
        .onAppear {
            setupBlobs()
        }
        .clipped()
        .ignoresSafeArea()
    }
    
    private func blobView(for blob: Blob, in size: CGSize, time: TimeInterval) -> some View {
        let x = blob.baseX * size.width + sin(time * blob.speed + blob.phase) * blob.amplitudeX
        let y = blob.baseY * size.height + cos(time * blob.speed * 0.8 + blob.phase) * blob.amplitudeY
        
        return Circle()
            .fill(blob.color)
            .frame(width: blob.size, height: blob.size)
            .position(x: x, y: y)
            .blur(radius: 50)
            .opacity(0.8)
    }
    
    // MARK: - Blob Setup
    
    private func setupBlobs() {
        blobs = (0..<blobCount).map { _ in
            Blob(
                baseX: CGFloat.random(in: 0.1...0.9),
                baseY: CGFloat.random(in: 0.1...0.9),
                amplitudeX: CGFloat.random(in: 150...300),
                amplitudeY: CGFloat.random(in: 150...300),
                speed: Double.random(in: 0.2...0.45),
                phase: Double.random(in: 0...(2 * .pi)),
                size: CGFloat.random(in: 320...550),
                color: [
                    Color(red: 0.20, green: 0.45, blue: 0.95),
                    Color(red: 0.35, green: 0.65, blue: 1.0),
                    Color(red: 0.10, green: 0.30, blue: 0.80),
                    Color(red: 0.45, green: 0.75, blue: 1.0)
                ].randomElement()!
            )
        }
    }
}

#Preview {
    PackBackground()
}
