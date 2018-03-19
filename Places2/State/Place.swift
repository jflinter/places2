//
//  Place.swift
//  Places2
//
//  Created by Jack Flintermann on 3/18/18.
//  Copyright © 2018 jflinter. All rights reserved.
//

import Foundation

struct Location: Equatable {
    static func ==(lhs: Location, rhs: Location) -> Bool {
        return lhs.lat == rhs.lat && lhs.lng == rhs.lng
    }
    
    let lat: Double
    let lng: Double
}

struct Place: Equatable {
    static func ==(lhs: Place, rhs: Place) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: String
    let title: String
    let location: Location
    let content: String
}
