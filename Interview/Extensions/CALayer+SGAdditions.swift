//
//  CALayer+SGAdditions.swift
//  Interview
//
//  Created by Developer on 7/30/18.
//  Copyright © 2018 Roman Ganzha. All rights reserved.
//


import Foundation
import UIKit

extension CALayer {
    
    func addRadius(radius: CGFloat?) {
        self.masksToBounds = true
        self.cornerRadius = radius ?? self.frame.size.height / 2
    }
    
    func addBorderWith(color: UIColor?,andWidth width: CGFloat?) {
        self.borderColor = (color ?? #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)).cgColor
        self.borderWidth = width ?? 1
    }
    
}
