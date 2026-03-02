//
//  ContentView.swift
//  iExpense
//
//  Created by Mylla on 24/02/26.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    let id = UUID()
    let name: String
    let type: String
    let amount: Double
}

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    var personal: [ExpenseItem] {
        items.filter { $0.type == "Personal" }
    }
    
    var business: [ExpenseItem] {
        items.filter { $0.type == "Business" }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decoded = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decoded
                return
            }
        }
        
        items = []
    }
}


struct ContentView: View {
    @ObservedObject private var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationStack {
            
            List {
                ItemsListView(expenses: expenses, type: "Personal")
                ItemsListView(expenses: expenses, type: "Business")
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button(action: {
                    showingAddExpense = true
                }) {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
            }
        }
    }
    
    
}

struct ItemsListView: View {
    @ObservedObject var expenses: Expenses
    let type: String
    
    var body: some View {
        Section(type) {
            ForEach(type == "Business" ? expenses.business : expenses.personal) { item in
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.headline)
                        Text(item.type)
                    }
                    Spacer()
                    Text(item.amount, format: .currency(code: "BRL"))
                }
            }
            .onDelete(perform: removeItems)
        }
        
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
