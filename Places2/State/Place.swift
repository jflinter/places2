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
        return lhs.id == rhs.id && lhs.title == rhs.title && lhs.content == rhs.content && lhs.location == rhs.location
    }
    
    let id: String
    var title: String
    var location: CLLocationCoordinate2D
    var content: String
}

extension CLLocationCoordinate2D: Equatable {
    public static func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
