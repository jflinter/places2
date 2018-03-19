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

    static let cellIdentifier = "Cell"
    
    var diffCalculator: SingleSectionTableViewDiffCalculator<Place>? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.accessibilityIdentifier = "place table view"
//        self.tableView.separatorEffect = UIVibrancyEffect(blurEffect: DrawerViewController.blurEffect)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: PlaceTableViewController.cellIdentifier)
        
        self.diffCalculator = SingleSectionTableViewDiffCalculator(tableView: self.tableView, initialRows: [], sectionIndex: 0)
        
        AppStore.shared.subscribe(self) { subscription in
            return subscription.select { state in
                return state.places
                }.skipRepeats(==)
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: PlaceTableViewController.cellIdentifier, for: indexPath)
        let blurEffect = UIBlurEffect(style: .light)
        cell.selectedBackgroundView = UIVisualEffectView(effect: blurEffect)
        let place = AppStore.shared.state.places.visible[indexPath.row]
        cell.textLabel?.text = place.title
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let diffCalculator = self.diffCalculator else { return }
        AppStore.shared.dispatch(AppActions.selectPlace(diffCalculator.rows[indexPath.row]))
    }

}
