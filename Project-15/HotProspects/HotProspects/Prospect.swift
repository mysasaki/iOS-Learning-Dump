//
//  Prospect.swift
//  HotProspects
//
//  Created by Mylla Sasaki on 01/06/26.
//

import SwiftData
import Foundation

@Model
class Prospect {
    var name: String
    var emailAddress: String
    var isContacted: Bool
    var registerDate = Date.now
    
    init(name: String, emailAddress: String, isContacted: Bool) {
        self.name = name
        self.emailAddress = emailAddress
        self.isContacted = isContacted
        self.registerDate = Date.now
    }
}
