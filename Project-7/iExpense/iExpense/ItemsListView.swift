//
//  ItemListView.swift
//  iExpense
//
//  Created by Mylla Sasaki on 15/05/26.
//

import SwiftUI
import SwiftData

struct ItemsListView: View {
    @Environment(\.modelContext) var modelContext
    @Query var expenses: [Expense]
        
    var body: some View {
        List {
            ForEach(expenses) {item in
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
            .onDelete(perform: deleteItem)
        }
    }
    
    init(expenseType: String, sortOrder:[SortDescriptor<Expense>]) {
        if(expenseType == "All") {
            _expenses = Query(sort: sortOrder)
        }
        else {
            _expenses = Query(filter: #Predicate<Expense>{ expense in
                expense.type == expenseType
            }, sort: sortOrder)
        }
    }
    
    func deleteItem(at offsets: IndexSet) {
        for offset in offsets {
            let expense = expenses[offset]
            modelContext.delete(expense)
        }
    }
}

#Preview {
    ItemsListView(expenseType: "Personal", sortOrder: [
        SortDescriptor(\Expense.name),
        SortDescriptor(\Expense.amount)])
}
