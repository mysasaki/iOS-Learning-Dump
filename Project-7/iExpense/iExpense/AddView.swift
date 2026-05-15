//
//  AddView.swift
//  iExpense
//
//  Created by Mylla on 26/02/26.
//

import SwiftUI
import SwiftData

struct AddView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var type = "Business"
    @State private var amount = 0.0
        
    let types = ["Business", "Personal"]
    
    var body: some View {
        
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                TextField("Amount", value: $amount, format: .currency(code: "BRL"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add new expense")
            .toolbar {
                ToolbarItem (placement:.confirmationAction) {
                    Button("Save") {
                        let item = Expense(name: name, type: type, amount: amount)
                        
                        modelContext.insert(item)
                        dismiss()
                    }
                }
                
                ToolbarItem (placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .navigationBarBackButtonHidden()
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
