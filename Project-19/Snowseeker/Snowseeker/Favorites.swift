//
//  Favorites.swift
//  Snowseeker
//
//  Created by Mylla Sasaki on 22/06/26.
//

import SwiftUI

@Observable
class Favorites {
    private var resorts: Set<String>
    private let key = "Favorites"
    
    init() {
        if let saved = UserDefaults.standard.array(forKey: key) as? [String] {
            resorts = Set(saved)
            return
        }
        
        resorts = []
    }
    
    func contains(_ resort: Resort) -> Bool {
        return resorts.contains(resort.id)
    }
    
    func add(_ resort: Resort) {
        resorts.insert(resort.id)
        save()
    }
    
    func remove(_ resort: Resort) {
        resorts.remove(resort.id)
        save()
    }
    
    func save() {
        UserDefaults.standard.set(Array(resorts), forKey: key)
    }
}
