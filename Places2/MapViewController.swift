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

class MapViewController: UIViewController, StoreSubscriber, MGLMapViewDelegate {
    
    private let mapView = MGLMapView(frame: .zero, styleURL: URL(string: "mapbox://styles/mapbox/streets-v10"))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mapView.frame = self.view.bounds
        self.mapView.delegate = self
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: 40.785091, longitude: -73.968285), zoomLevel: 9, animated: false)
        view.addSubview(mapView)
        
        // Add a gesture recognizer to the map view
        let setDestination = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        mapView.addGestureRecognizer(setDestination)
        
        AppStore.shared.subscribe(self) { subscription in
            return subscription.select { state in
                return state.places
                }.skipRepeats(==)
        }
    }
    
    @objc func didLongPress(_ sender: UILongPressGestureRecognizer) {
        guard sender.state == .began else { return }
        
        // Converts point where user did a long press to map coordinates
        let point = sender.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        AppStore.shared.dispatch(AppActions.addPlace(coordinate))
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
        for annotation in (self.mapView.annotations ?? []) {
            guard let annotation = annotation as? PlaceAnnotation else { continue }
            if annotation.place.id == state.selectedID {
                self.mapView.selectAnnotation(annotation, animated: true)
            } else {
                self.mapView.deselectAnnotation(annotation, animated: true)
            }
        }
    }
    
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        guard let annotation = annotation as? PlaceAnnotation else { return }
        AppStore.shared.dispatch(AppActions.selectPlace(annotation.place))
    }
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        // This example is only concerned with point annotations.
        guard annotation is PlaceAnnotation else {
            return nil
        }
        
        // Use the point annotation’s longitude value (as a string) as the reuse identifier for its view.
        let reuseIdentifier = "\(annotation.coordinate.longitude) \(annotation.coordinate.latitude)"
        
        // For better performance, always try to reuse existing annotations.
        return mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) ?? PlaceAnnotationView(reuseIdentifier: reuseIdentifier)
    }

}

private class PlaceAnnotationView: MGLAnnotationView {
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.backgroundColor = selected ? UIColor.green : UIColor.red
        // Animate the border width in/out, creating an iris effect.
        let animation = CABasicAnimation(keyPath: "borderWidth")
        animation.duration = 0.1
        self.layer.borderWidth = selected ? frame.width / 4 : 2
        self.layer.add(animation, forKey: "borderWidth")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Use CALayer’s corner radius to turn this view into a circle.
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.white.cgColor
    }
}

private class PlaceAnnotation: NSObject, MGLAnnotation {
    let place: Place
    init(_ p: Place) {
        self.place = p
    }
    var coordinate: CLLocationCoordinate2D {
        return self.place.location
    }
    
}


