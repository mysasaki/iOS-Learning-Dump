//
//  Card.swift
//  Flashzilla
//
//  Created by Mylla Sasaki on 04/06/26.
//

import Foundation

struct Card: Identifiable, Codable {
    var id = UUID()
    var prompt: String
    var answer: String
    
    static let example = Card(prompt: "What is the capital of Japan", answer: "Tokyo")
}
