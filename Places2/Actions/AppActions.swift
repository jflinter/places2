//
//  AppActions.swift
//  Places2
//
//  Created by Jack Flintermann on 3/19/18.
//  Copyright © 2018 jflinter. All rights reserved.
//

import Foundation
import ReSwift
import CoreLocation

enum AppActionType {
    case addPlace(location: CLLocationCoordinate2D)
    case selectPlace(place: Place)
}

enum AppActions {} // will be extended with static functions.

protocol AppAction: Action {
    var type: AppActionType { get }
}

extension AppActions {
    static func addPlace(_ location: CLLocationCoordinate2D) -> Action {
        return AddPlaceAction(location)
    }
    
    static func selectPlace(_ place: Place) -> Action {
        return SelectPlaceAction(place)
    }
}

fileprivate struct AddPlaceAction: AppAction {
    let type: AppActionType
    init(_ l: CLLocationCoordinate2D) {
        self.type = .addPlace(location: l)
    }
}

fileprivate struct SelectPlaceAction: AppAction {
    let type: AppActionType
    init(_ p: Place) {
        self.type = .selectPlace(place: p)
    }
}

