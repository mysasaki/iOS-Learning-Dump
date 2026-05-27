//
//  Location.swift
//  BucketList
//
//  Created by Mylla Sasaki on 25/05/26.
//

import Foundation
import CoreLocation

struct Location: Codable, Equatable, Identifiable {
    #if DEBUG
    static let example = Location(id: UUID(), name: "Palace", description: "Nice place", latitude: 51.501, longitude: -0.141)
    #endif
    
    var id: UUID
    var name: String
    var description: String
    var latitude: Double
    var longitude: Double
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    // More optimized than letting Swift compare every property
    static func ==(lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
}
