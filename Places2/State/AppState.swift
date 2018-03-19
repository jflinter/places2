//
//  AppState.swift
//  Places2
//
//  Created by Jack Flintermann on 3/18/18.
//  Copyright © 2018 jflinter. All rights reserved.
//

import ReSwift
import Foundation
import CoreLocation

// Think of this as a database. Each struct is a table. Each model here should be as *normalized* as possible.
struct AppState: StateType {
    var places = PlaceState()
    var accessToken: String? = nil
}

struct PlaceState: Equatable {
    static func ==(lhs: PlaceState, rhs: PlaceState) -> Bool {
        return lhs.byID == rhs.byID && lhs.selectedID == rhs.selectedID
    }
    
    private static let testPlaces = [
        Place(
            id: "abc",
            title: "Central Park",
            location: CLLocationCoordinate2DMake(40.785091, -73.968285),
            content: ""
        )
    ]
    private static let testPlacesZipped = zip(PlaceState.testPlaces.map {$0.id}, testPlaces)
    
//    private var byID: [String: Place] = [:]
    var byID: [String: Place] = Dictionary(uniqueKeysWithValues: PlaceState.testPlacesZipped)
    var selectedID: String? = nil
    var editing: Place? = nil
    private var all: [Place] { return Array(self.byID.values) }
    var visible: [Place] { return self.all }
    var selected: Place? {
        guard let id = selectedID else { return nil }
        return byID[id]
    }
}

