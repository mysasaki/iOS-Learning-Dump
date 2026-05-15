//
//  Job.swift
//  SwiftDataProject
//
//  Created by Mylla Sasaki on 15/05/26.
//

import SwiftData

@Model
class Job {
    var name: String
    var priority: Int
    var owner: User?
    
    init(name: String, priority: Int, owner: User? = nil) {
        self.name = name
        self.priority = priority
        self.owner = owner
    }
}
