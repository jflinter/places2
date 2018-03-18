//
//  Place.swift
//  Places2
//
//  Created by Jack Flintermann on 3/18/18.
//  Copyright © 2018 jflinter. All rights reserved.
//

import Foundation

struct Location {
    let lat: Double
    let lng: Double
}

struct Place {
    let id: String
    let location: Location
    let content: String
}
