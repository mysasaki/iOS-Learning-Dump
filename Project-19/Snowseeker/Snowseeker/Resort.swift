//
//  Resort.swift
//  Snowseeker
//
//  Created by Mylla Sasaki on 18/06/26.
//

import Foundation

struct Resort: Codable, Hashable, Identifiable {
    let id: String
    let name: String
    var country: String
    var description: String
    var imageCredit: String
    var price: Int
    var size: Int
    var snowDepth: Int
    var elevation: Int
    var runs: Int
    var facilities: [String]
    var facilityType: [Facility] {
        facilities.map(Facility.init)
    }
    
    static let allResorts: [Resort] = Bundle.main.decode("resorts.json")
    static let example = allResorts[0]
}
