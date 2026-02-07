//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Mylla on 03/02/26.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var stage = 1
    @State private var showingScore = false
    @State private var showingEnd = false
    @State private var scoreTitle = ""
    @State private var message = ""
    @State private var score = 0
    
    var body: some View {
        
        ZStack {
            RadialGradient(stops: [
                .init(color: .mint, location: 0.3),
                .init(color: .black, location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                VStack(spacing:15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .foregroundStyle(.white)
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .cornerRadius(15)
                                .shadow(radius: 5 )
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .cornerRadius(15)
                
                Spacer()
                Spacer()
                Text("Stage: \(stage)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            if !message.isEmpty
            {
                Text(message)
            }
            
            Text("Your score is \(score)")
        }
        .alert("Game over", isPresented: $showingEnd) {
            Button("Restart", action: restartGame)
        } message: {
            Text("Your final score was: \(score)")
        }
    }
        
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            message = ""
            score += 1
        }
        else {
            scoreTitle = "Wrong"
            message = "That's the flag of \(countries[number])"
        }
        
        if(stage < 8) {
            showingScore = true
        }
        else {
            showingEnd = true
        }
    }
    
    func askQuestion() {
        stage += 1
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func restartGame() {
        stage = 0
        score = 0
        askQuestion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
