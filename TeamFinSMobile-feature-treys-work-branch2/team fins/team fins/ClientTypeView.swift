//
//  ClientTypeView.swift
//  team fins
//
//  Created by Trey Baugher on 10/22/16.
//  Copyright © 2016 Team Fins. All rights reserved.
//

import UIKit

class ClientTypeView: UIView {
    @IBOutlet weak var typeLabel: UILabel?
    @IBOutlet weak var typeImageView: UIImageView?
    var selected = false
    var typeName = "men"

    @IBAction func toggleSelection() {
        selected = !selected
        updateDisplayForState()
    }
    
    func representType(name: String) {
        typeName = name
        updateDisplayForState()
    }
    
    func updateDisplayForState() {
        let imageName = "icon-" + typeName + (selected ? "_active" : "_inactive")
        typeImageView?.image = UIImage(named: imageName)
        typeLabel?.textColor = (selected ? InterfaceTheme.uiKeyColor() : InterfaceTheme.darkTextColor())
    }
}
