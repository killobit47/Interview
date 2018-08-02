//
//  IButton.swift
//  Interview
//
//  Created by Developer on 7/30/18.
//  Copyright © 2018 Roman Ganzha. All rights reserved.
//

import UIKit

@IBDesignable
class IButton: UIButton {

    override var backgroundColor: UIColor? {
        didSet {
            clipsToBounds = true
            layer.addRadius(radius: nil)
        }
    }
    
    @IBInspectable public var borderColor: UIColor? {
        set {
            layer.addBorderWith(color: newValue, andWidth: 1)
        }
        get {
            return self.borderColor
        }
    }
    
    override func draw(_ rect: CGRect) {
        titleLabel?.numberOfLines = 1
        titleLabel?.adjustsFontSizeToFitWidth = true
        layer.addRadius(radius: nil)
    }
    
}
