//
//  PlaceTableViewController.swift
//  Places2
//
//  Created by Jack Flintermann on 3/18/18.
//  Copyright © 2018 jflinter. All rights reserved.
//

import UIKit
import Dwifft
import ReSwift

class PlaceTableViewController: UITableViewController, StoreSubscriber {

    static let cellIdentifier = "PlaceTableViewCell"
    
    var diffCalculator: SingleSectionTableViewDiffCalculator<Place>? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.accessibilityIdentifier = "place table view"
//        self.tableView.separatorEffect = UIVibrancyEffect(blurEffect: DrawerViewController.blurEffect)
        self.tableView.register(UINib.init(nibName: PlaceTableViewController.cellIdentifier, bundle: nil), forCellReuseIdentifier: PlaceTableViewController.cellIdentifier)
        
        self.diffCalculator = SingleSectionTableViewDiffCalculator(tableView: self.tableView, initialRows: [], sectionIndex: 0)
        
        AppStore.shared.subscribe(self) { subscription in
            return subscription.select { state in
                return state.places
                }.skipRepeats(==)
        }
        
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    // MARK: - Store Subscriber
    
    func newState(state: PlaceState) {
        self.diffCalculator?.rows = state.visible
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.diffCalculator?.rows.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlaceTableViewController.cellIdentifier, for: indexPath) as! PlaceTableViewCell
        let blurEffect = UIBlurEffect(style: .light)
        cell.selectedBackgroundView = UIVisualEffectView(effect: blurEffect)
        let place = AppStore.shared.state.places.visible[indexPath.row]
        cell.configure(withPlace: place)
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let diffCalculator = self.diffCalculator else { return nil }
        let place = diffCalculator.rows[indexPath.row]
        if AppStore.shared.state.places.selected == place {
            tableView.deselectRow(at: indexPath, animated: true)
            self.tableView(tableView, didDeselectRowAt: indexPath)
            AppStore.shared.dispatch(AppActions.selectPlace(nil))
            return nil
        } else {
            AppStore.shared.dispatch(AppActions.selectPlace(place))
            return indexPath
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }

}
