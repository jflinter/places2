//
//  DrawerViewController.swift
//  Places2
//
//  Created by Jack Flintermann on 3/18/18.
//  Copyright © 2018 jflinter. All rights reserved.
//

import UIKit
import Pulley

class DrawerViewController: UIViewController, PulleyDrawerViewControllerDelegate {

    static let blurEffect = UIBlurEffect(style: .extraLight)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        self.view.accessibilityIdentifier = "drawer view"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let drawer = self.parent as? PulleyViewController {
            drawer.drawerBackgroundVisualEffectView = UIVisualEffectView(effect: DrawerViewController.blurEffect)
        }
    }
    
    func collapsedDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return 68.0 + bottomSafeArea
    }
    
    func partialRevealDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return 264.0 + bottomSafeArea
    }
    
    func supportedDrawerPositions() -> [PulleyPosition] {
        return [PulleyPosition.partiallyRevealed, PulleyPosition.open, PulleyPosition.collapsed]
    }
}
