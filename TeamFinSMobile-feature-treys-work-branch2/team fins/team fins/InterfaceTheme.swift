//
//  InterfaceTheme.swift
//  team fins
//
//  Created by Trey Baugher on 10/22/16.
//  Copyright © 2016 Team Fins. All rights reserved.
//

import UIKit

struct InterfaceTheme {
    static func keyColor() -> CGColor {
        return InterfaceTheme.uiKeyColor().cgColor
    }
    
    static func darkTextColor() -> UIColor {
        return UIColor(red: 45/255.0, green: 44/255.0, blue: 56/255.0, alpha: 1.0)
    }
    
    static func uiKeyColor() -> UIColor {
        return UIColor(red: 50/255.0, green: 213/255.0, blue: 242/255.0, alpha: 1.0)
    }
    
}
