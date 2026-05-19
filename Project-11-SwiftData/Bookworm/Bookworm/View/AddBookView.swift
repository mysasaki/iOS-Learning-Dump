//
//  AddBookView.swift
//  Bookworm
//
//  Created by Mylla Sasaki on 10/05/26.
//

import SwiftUI
import SwiftData

struct AddBookView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var author = ""
    @State private var genre = "Fantasy"
    @State private var review = ""
    @State private var rating = 3
    @State private var isShowingError = false
    
    let genres = ["Fantasy", "Romance", "Horror", "Kids", "Mystery", "Poetry", "Thriller"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                        .textInputAutocapitalization(.words)
                    TextField("Author", text: $author)
                        .textInputAutocapitalization(.words)
                    
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                    
                }
                
                Section("Write a review") {
                    TextEditor(text: $review)
                    RatingView(rating: $rating)
                }
                
                Button("Save") {
                    guard !title.isEmpty,
                          !author.isEmpty,
                          !genre.isEmpty else {
                        
                        isShowingError = true
                        return
                    }
                    
                    let newBook = Book(title: title, author: author, genre: genre, review: review, rating: rating)
                    modelContext.insert(newBook)
                    
                    dismiss()
                }
            }
            .navigationTitle("Add Book")
            .alert("Error", isPresented: $isShowingError) {
                Button("Ok", role: .cancel) {}
            } message: {
                Text("Please insert Name, Author and Genre")
            }
        }
    }
}

#Preview {
    AddBookView()
}
