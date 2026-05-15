//
//  SwiftDataProjectApp.swift
//  SwiftDataProject
//
//  Created by Mylla Sasaki on 14/05/26.
//

import SwiftUI
import SwiftData

@main
struct SwiftDataProjectApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: User.self)
    }
}
