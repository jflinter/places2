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
    return state
        |> (prop(\AppState.places)) { placeReducer(action, $0)}
}

func placeReducer(_ action: Action, _ state: PlaceState) -> PlaceState {
    return state
}
