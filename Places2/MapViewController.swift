//
//  MapViewController.swift
//  Places2
//
//  Created by Jack Flintermann on 3/18/18.
//  Copyright © 2018 jflinter. All rights reserved.
//

import UIKit
import Mapbox
import ReSwift
import Dwifft

class MapViewController: UIViewController, StoreSubscriber {
    
    private let mapView = MGLMapView(frame: .zero, styleURL: URL(string: "mapbox://styles/mapbox/streets-v10"))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mapView.frame = self.view.bounds
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: 40.785091, longitude: -73.968285), zoomLevel: 9, animated: false)
        view.addSubview(mapView)
        
        AppStore.shared.subscribe(self) { subscription in
            return subscription.select { state in
                return state.places
                }.skipRepeats(==)
        }
    }
    
    var currentPlaces: [Place] = []
    private var annotations: [String: PlaceAnnotation] = [:]
    func newState(state: PlaceState) {
        let diff = Dwifft.diff(currentPlaces, state.visible)
        diff.forEach { step in
            switch step {
            case .delete(_, let v):
                if let p = annotations.removeValue(forKey: v.id) {
                    self.mapView.removeAnnotation(p)
                }
            case .insert(_, let v):
                let p = PlaceAnnotation(v)
                annotations[v.id] = p
                self.mapView.addAnnotation(p)
            }
        }
    }
    
    

}

private class PlaceAnnotation: NSObject, MGLAnnotation {
    let place: Place
    init(_ p: Place) {
        self.place = p
    }
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(self.place.location.lat, self.place.location.lng)
    }
    
}


