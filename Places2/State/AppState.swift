//
//  AppState.swift
//  Places2
//
//  Created by Jack Flintermann on 3/18/18.
//  Copyright © 2018 jflinter. All rights reserved.
//

import ReSwift
import Foundation

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
            location: Location(lat: 40.785091, lng: -73.968285),
            content: ""
        )
    ]
    private static let testPlacesZipped = zip(PlaceState.testPlaces.map {$0.id}, testPlaces)
    
//    private var byID: [String: Place] = [:]
    private var byID: [String: Place] = Dictionary(uniqueKeysWithValues: PlaceState.testPlacesZipped)
    private var selectedID: String? = nil
    private var all: [Place] { return Array(self.byID.values) }
    var visible: [Place] { return self.all }
    var selected: Place? {
        guard let id = selectedID else { return nil }
        return byID[id]
    }
}

