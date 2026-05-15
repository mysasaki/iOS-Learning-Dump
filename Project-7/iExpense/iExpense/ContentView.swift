//
//  ContentView.swift
//  iExpense
//
//  Created by Mylla on 24/02/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {    
    @State private var sortOrder = [SortDescriptor(\Expense.name), SortDescriptor(\Expense.amount)]
    @State private var selectedType = "All"
    
    var expenseTypes = ["All", "Personal", "Business"]
    
    var body: some View {
        NavigationStack {
            ItemsListView(expenseType: selectedType, sortOrder: sortOrder)
            .navigationTitle("iExpense")
            .toolbar {
                NavigationLink {
                    AddView()
                } label: {
                    Image(systemName: "plus")
                }
                
                Menu("Filter", systemImage: "line.3.horizontal.decrease") {
                    Picker("Expense type", selection: $selectedType) {
                        ForEach(expenseTypes, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Menu("Sort", systemImage: "arrow.up.arrow.down") {
                    Picker("Sort expenses", selection: $sortOrder) {
                        Text("Sort by Name")
                            .tag([
                                SortDescriptor(\Expense.name),
                                SortDescriptor(\Expense.amount)
                            ])
                        
                        Text("Sort by Amount")
                            .tag([
                                SortDescriptor(\Expense.amount),
                                SortDescriptor(\Expense.name)
                            ])
                    }
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
