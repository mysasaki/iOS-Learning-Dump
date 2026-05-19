//
//  BookwormApp.swift
//  Bookworm
//
//  Created by Mylla Sasaki on 05/05/26.
//

import SwiftData
import SwiftUI

@main
struct BookwormApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Book.self)
    }
}
