//
//  AppReducer.swift
//  Places2
//
//  Created by Jack Flintermann on 3/18/18.
//  Copyright © 2018 jflinter. All rights reserved.
//

import ReSwift
import Foundation

func appReducer(_ action: Action, _ state: AppState?) -> AppState {
    let state = state ?? AppState()
    guard let action = action as? AppAction else { return state }
    return state
        |> (prop(\AppState.places)) { placeReducer(action, $0)}
}

func placeReducer(_ action: AppAction, _ state: PlaceState) -> PlaceState {
    switch action.type {
    case .selectPlace(let place):
        return state |> (prop(\PlaceState.selectedID)) { _ in return place.id }
    case .addPlace(let location):
        let place = Place(id: NSUUID().uuidString, title: "New Place", location: location, content: "")
        return state
            |> (prop(\PlaceState.selectedID)) { _ in return place.id }
            |> (prop(\PlaceState.byID) <<< prop(\.[place.id])) { _ in place }
    }
}
