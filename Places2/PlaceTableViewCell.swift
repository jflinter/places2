//
//  PlaceTableViewCell.swift
//  Places2
//
//  Created by Jack Flintermann on 3/20/18.
//  Copyright © 2018 jflinter. All rights reserved.
//

import UIKit
import ReSwift
import CoreLocation
import MapKit

class PlaceTableViewCell: UITableViewCell, StoreSubscriber {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var contentsLabel: UILabel!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var buttonHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.buttonHeightConstraint.constant = 0
        self.bottomStackView.alpha = 0
        self.distanceLabel.text = ""
        AppStore.shared.subscribe(self) { subscription in
            return subscription.select { state in
                return state.userLocation
            }.skipRepeats(==)
        }
    }
    
    override var textLabel: UILabel? {
        return self.titleLabel
    }
    
    @IBAction func edit() {
        guard let place = self.place else { return }
        AppStore.shared.dispatch(AppActions.editPlace(place))
    }
    
    var place: Place? = nil
    func configure(withPlace place: Place) {
        self.titleLabel.text = place.title
        self.place = place
        updateLocation()
    }
    
    var userLocation: CLLocationCoordinate2D? = nil
    func newState(state: CLLocationCoordinate2D?) {
        self.userLocation = state
        updateLocation()
    }
    
    func updateLocation() {
        if let location1 = self.userLocation, let location2 = self.place?.location {
            let distance = CLLocation.distance(from: location1, to: location2)
            self.distanceLabel.text = MKDistanceFormatter.forPlaceCells.string(fromDistance: distance)
        } else {
            self.distanceLabel.text = ""
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        let constant: CGFloat = selected ? 30.0 : 0.0
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
            self.buttonHeightConstraint.constant = constant
            self.contentsLabel.text = selected ? self.place?.content : ""
            self.bottomStackView.alpha = selected ? 1 : 0
            self.layoutIfNeeded()
        }, completion: nil)
    }
}

private extension MKDistanceFormatter {
    static let forPlaceCells: MKDistanceFormatter = {
        let formatter = MKDistanceFormatter()
        formatter.unitStyle = MKDistanceFormatterUnitStyle.abbreviated
        return formatter
    }()
}

private extension CLLocation {
    
    /// Get distance between two points
    ///
    /// - Parameters:
    ///   - from: first point
    ///   - to: second point
    /// - Returns: the distance in meters
    class func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return from.distance(from: to)
    }
}
