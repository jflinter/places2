//
//  Place.swift
//  Places2
//
//  Created by Jack Flintermann on 3/18/18.
//  Copyright © 2018 jflinter. All rights reserved.
//

import Foundation
import CoreLocation

struct Place: Equatable {
    static func ==(lhs: Place, rhs: Place) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: String
    let title: String
    let location: CLLocationCoordinate2D
    let content: String
}
