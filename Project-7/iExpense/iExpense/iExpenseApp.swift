//
//  iExpenseApp.swift
//  iExpense
//
//  Created by Mylla on 24/02/26.
//

import SwiftUI
import SwiftData

@main
struct iExpenseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Expense.self)
    }
}
