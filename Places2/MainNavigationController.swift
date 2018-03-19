//
//  MainNavigationController.swift
//  Places2
//
//  Created by Jack Flintermann on 3/19/18.
//  Copyright © 2018 jflinter. All rights reserved.
//

import UIKit
import ReSwift

class MainNavigationController: UINavigationController, StoreSubscriber {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppStore.shared.subscribe(self) { subscription in
            return subscription.select { state in
                return state.places.editing
            }.skipRepeats(==)
        }
    }
    
    // editingID
    func newState(state: Place?) {
        if self.presentedViewController != nil {
            self.dismiss(animated: true, completion: nil)
        }
        if let state = state {
            let editor = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditPlaceViewController") as! EditPlaceViewController
            editor.configure(withPlace: state)
            self.present(editor, animated: true, completion: nil)
        }
    }

}
