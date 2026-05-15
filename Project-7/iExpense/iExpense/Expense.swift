//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Mylla Sasaki on 15/05/26.
//

import Foundation
import SwiftData

@Model
class Expense {
    var id = UUID()
    var name: String
    var type: String
    var amount: Double
    
    init(name: String, type: String, amount: Double) {
        self.name = name
        self.type = type
        self.amount = amount
    }
}
