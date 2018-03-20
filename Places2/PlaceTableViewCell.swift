//
//  PlaceTableViewCell.swift
//  Places2
//
//  Created by Jack Flintermann on 3/20/18.
//  Copyright © 2018 jflinter. All rights reserved.
//

import UIKit

class PlaceTableViewCell: UITableViewCell {

    @IBOutlet weak var bottomHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentsLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bottomHeightConstraint.constant = 0
        self.bottomStackView.alpha = 0
    }
    
    override var textLabel: UILabel? {
        return self.titleLabel
    }
    
    func configure(withPlace place: Place) {
        self.titleLabel.text = place.title
        self.contentsLabel.text = place.content
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        let constant: CGFloat = selected ? 30.0 : 0.0
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
            self.bottomHeightConstraint.constant = constant
            self.bottomStackView.alpha = selected ? 1 : 0
            self.layoutIfNeeded()
        }, completion: nil)
    }
}
