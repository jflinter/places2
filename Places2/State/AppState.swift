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

struct PlaceState {
    private static let testPlaces = [
        Place(id: "abc", location: Location(lat: 40.785091, lng: -73.968285), content: "Central Park")
    ]
    private static let testPlacesZipped = zip(PlaceState.testPlaces.map {$0.id}, testPlaces)
    
//    private var byID: [String: Place] = [:]
    private var byID: [String: Place] = Dictionary(uniqueKeysWithValues: PlaceState.testPlacesZipped)
    private var selectedID: String? = nil
    var all: [Place] { return Array(self.byID.values) }
    var selected: Place? {
        guard let id = selectedID else { return nil }
        return byID[id]
    }
}

