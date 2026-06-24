//
//  ContentView.swift
//  LayoutGeometry
//
//  Created by Mylla Sasaki on 09/06/26.
//

import SwiftUI

struct ContentView: View {
    var colors: [Color] = [.red, .orange, .white, .pink, .purple]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(1..<20) { number in
                    Text("Number: \(number)")
                        .font(.largeTitle)
                        .padding()
                        .background(.red)
                        .frame(width: 200, height: 200)
                        .visualEffect { content, proxy in
                            content
                                .rotation3DEffect(.degrees(-proxy.frame(in: .global).minX / 8), axis: (x: 0, y: 1, z: 0))
                        }
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
    }
}

#Preview {
    ContentView()
}
