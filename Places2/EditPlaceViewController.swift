//
//  EditPlaceViewController.swift
//  Places2
//
//  Created by Jack Flintermann on 3/19/18.
//  Copyright © 2018 jflinter. All rights reserved.
//

import UIKit

class EditPlaceViewController: UIViewController {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var contentsView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    private var place: Place? = nil
    func configure(withPlace place: Place) {
        self.place = place
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.titleField.text = self.place?.title
        self.contentsView.text = self.place?.content
    }
    
    @IBAction func cancel() {
        AppStore.shared.dispatch(AppActions.cancelEditing())
    }
    
    @IBAction func done() {
        guard let place = self.place else { return }
        let p = place
            |> (prop(\Place.title)) { _ in self.titleField.text ?? "" }
            |> (prop(\Place.content)) { _ in self.contentsView.text ?? "" }
        AppStore.shared.dispatch(AppActions.savePlace(p))
    }

}
