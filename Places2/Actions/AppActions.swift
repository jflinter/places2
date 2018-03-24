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
    case selectPlace(place: Place?)
    case editPlace(place: Place)
    case cancelEditing
    case savePlace(place: Place)
    
    case userMoved(location: CLLocationCoordinate2D?)
}

enum AppActions {} // will be extended with static functions.

protocol AppAction: Action {
    var type: AppActionType { get }
}

private struct ActionWrapper: AppAction {
    let type: AppActionType
    init(_ type: AppActionType) {
        self.type = type
    }
}

// location stuff
extension AppActions {
    static func userMoved(_ location: CLLocationCoordinate2D?) -> Action {
        return ActionWrapper(.userMoved(location: location))
    }
}

// place stuff
extension AppActions {
    static func addPlace(_ location: CLLocationCoordinate2D) -> Action {
        return AddPlaceAction(location)
    }
    
    static func editPlace(_ place: Place) -> Action {
        return EditPlaceAction(place)
    }
    
    static func cancelEditing() -> Action {
        return CancelEditingAction()
    }
    
    static func selectPlace(_ place: Place?) -> Action {
        return SelectPlaceAction(place)
    }
    
    static func savePlace(_ place: Place) -> Action {
        return SavePlaceAction(place)
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
    init(_ p: Place?) {
        self.type = .selectPlace(place: p)
    }
}

fileprivate struct EditPlaceAction: AppAction {
    let type: AppActionType
    init(_ p: Place) {
        self.type = .editPlace(place: p)
    }
}

fileprivate struct CancelEditingAction: AppAction {
    let type = AppActionType.cancelEditing
}

fileprivate struct SavePlaceAction: AppAction {
    let type: AppActionType
    init(_ p: Place) {
        self.type = .savePlace(place: p)
    }
}

