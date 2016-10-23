//
//  BorderedButton.swift
//  team fins
//
//  Created by Trey Baugher on 10/22/16.
//  Copyright © 2016 Team Fins. All rights reserved.
//

import UIKit

class BorderedButton: UIButton {
    public var roundRectCornerRadius: CGFloat = 2.0 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        layoutRoundRectLayer()
    }
    
    private func layoutRoundRectLayer() {
        layer.cornerRadius = roundRectCornerRadius
        layer.borderWidth = 2.0
        layer.borderColor = InterfaceTheme.keyColor()
    }
}
