//
//  EditCards.swift
//  Flashzilla
//
//  Created by Mylla Sasaki on 07/06/26.
//

import SwiftUI

struct EditCards: View {
    @Environment(\.dismiss) var dismiss
    
    let url = URL.documentsDirectory.appending(path:"cards.txt")
    
    @State private var cards = [Card]()
    @State private var newPrompt = ""
    @State private var newAnswer = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section("Add new card") {
                    TextField("Prompt", text: $newPrompt)
                    TextField("Answer", text: $newAnswer)
                    Button("Add card", action: addCard)
                }
                
                Section {
                    ForEach(0..<cards.count, id:\.self) { index in
                        VStack(alignment: .leading) {
                            Text(cards[index].prompt)
                                .font(.headline)
                            Text(cards[index].answer)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .onDelete(perform: removeCards)
                }
            }
            .navigationTitle("Edit Cards")
            .toolbar {
                Button("Done", action: done)
            }
            .onAppear(perform: loadData)
        }
    }
    
    func done() {
        dismiss()
    }
    
    func loadData() {
        do {
            let data = try Data(contentsOf: url)
            cards = try JSONDecoder().decode([Card].self, from: data)
        }
        catch {
            print("Unable to load data: \(error.localizedDescription)")
        }
    }
    
    func saveData() {
        do {
            let data = try JSONEncoder().encode(cards)
            try data.write(to: url, options: [.atomic])
        }
        catch {
            print("Unable to save data: \(error.localizedDescription)")
        }
    }
    
    func addCard() {
        let trimmedPrompt = newPrompt.trimmingCharacters(in: .whitespaces)
        let trimmedAnswer = newAnswer.trimmingCharacters(in: .whitespaces)
        
        guard trimmedPrompt.isEmpty == false && trimmedAnswer.isEmpty == false else { return }
        
        let card = Card(prompt: newPrompt, answer: newAnswer)
        cards.insert(card, at: 0)
        saveData()
        clearFields()
    }
    
    func clearFields() {
        newAnswer = ""
        newPrompt = ""
    }
    
    func removeCards(at offsets: IndexSet) {
        cards.remove(atOffsets: offsets)
        saveData()
    }
}

#Preview {
    EditCards()
}
