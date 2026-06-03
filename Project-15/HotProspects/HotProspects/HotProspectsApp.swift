//
//  HotProspectsApp.swift
//  HotProspects
//
//  Created by Mylla Sasaki on 29/05/26.
//

import SwiftUI
import SwiftData

@main
struct HotProspectsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Prospect.self)
    }
}
