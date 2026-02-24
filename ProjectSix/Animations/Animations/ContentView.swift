//
//  ContentView.swift
//  Animations
//
//  Created by Mylla on 18/02/26.
//

import SwiftUI

struct ContentView: View {
        
    @State private var showingRed = false
    
    var body: some View {
        
        VStack {
            Button("Tap me"){
                withAnimation {
                    showingRed.toggle()
                }
            }
            
            if showingRed {
                Text("Boo")
                    .padding(40)
                    .background(.red)
                    .foregroundStyle(.white)
                    .clipShape(Circle())
                    .transition(.scale)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
