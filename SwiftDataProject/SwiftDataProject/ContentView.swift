//
//  ContentView.swift
//  SwiftDataProject
//
//  Created by Mylla Sasaki on 14/05/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @State private var showingUpcomingOnly = false
    @State private var sortOrder = [
        SortDescriptor(\User.name), SortDescriptor(\User.joinDate)]
    
    var body: some View {
        NavigationStack() {
            UsersView(minimumJoinDate: showingUpcomingOnly ? .now : .distantPast, sortOrder: sortOrder)
            .navigationTitle("Users")
            .toolbar {
                Button("Add Samples", systemImage: "plus") {
                    
                    try? modelContext.delete(model: User.self) // deleta todo o existing data
                    
                    let first = User(name: "Beatrice", city: "London", joinDate: .now.addingTimeInterval(86400 * -10))
                    let second = User(name: "Alice", city: "Berlin", joinDate: .now.addingTimeInterval(86400 * -5))
                    let third = User(name: "Deann", city: "New York", joinDate: .now.addingTimeInterval(86400 * 5))
                    let fourth = User(name: "Caroline", city: "Berlin", joinDate: .now.addingTimeInterval(86400 * 10))
                    
                    modelContext.insert(first)
                    modelContext.insert(second)
                    modelContext.insert(third)
                    modelContext.insert(fourth)
                }
                
                Button(showingUpcomingOnly ? "Show everyobe" : "Show upcoming") {
                    showingUpcomingOnly.toggle()
                }
                
                Menu("Sort", systemImage: "arrow.up.arrow.down") {
                    Picker("Sort", selection: $sortOrder) {
                        Text("Sort by name")
                            .tag([
                                SortDescriptor(\User.name),
                                SortDescriptor(\User.joinDate)
                            ])
                        
                        Text("Sort by date")
                            .tag([
                                SortDescriptor(\User.joinDate),
                                SortDescriptor(\User.name)
                            ])
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
