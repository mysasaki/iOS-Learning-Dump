//
//  ContentView.swift
//  WordScramble
//
//  Created by Mylla on 11/02/26.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showError = false
    @State private var score = 0
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        TextField("Enter your word", text: $newWord)
                            .textInputAutocapitalization(.never)
                        Text("score: \(score)")
                    }
                }
                
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showError, actions: {
                //auto button OK
            }, message: {
                Text(errorMessage)
            })
            .toolbar(content: {
                Button("Refresh", action: startGame)
            })
        }
    }
    
    func startGame() {
        score = 0
        usedWords.removeAll()
        newWord = ""
        
        if let startWordURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        fatalError("Could not load start.txt from bundle.")
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else { return }
        
        guard hasEnoughCharacters(word: answer) else {
            wordError(title: "Word is too short", message: "Type a longer word")
            return
        }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word already used", message: "Try another word")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that from \(rootWord)")
            return
        }
        
        guard isValid(word: answer) else {
            wordError(title: "Word not recognized", message: "Make sure word exists")
            return
        }
        
        withAnimation() {
            usedWords.insert(answer, at: 0)
            score += 2 * answer.count
        }
        
        newWord = ""
    }
    
    func hasEnoughCharacters(word: String) -> Bool {
        return word.count >= 3
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var temp = rootWord
        
        for letter in word {
            if let pos = temp.firstIndex(of: letter) {
                temp.remove(at: pos)
            }
            else {
                return false
            }
        }
        
        return true
    }
    
    func isValid(word: String) ->  Bool {
       let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        
        let misspellRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspellRange.location == NSNotFound
    }
    
    func wordError(title:String, message:String) {
        errorTitle = title
        errorMessage = message
        showError = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
