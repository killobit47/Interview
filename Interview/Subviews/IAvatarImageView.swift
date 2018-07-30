//
//  IAvatarImageView.swift
//  Interview
//
//  Created by Developer on 7/30/18.
//  Copyright © 2018 Roman Ganzha. All rights reserved.
//

import UIKit

class IAvatarImageView: UIImageView {

    override var frame: CGRect {
        didSet {
            makeRound()
        }
    }
    
    override var bounds: CGRect {
        didSet {
            makeRound()
        }
    }
    
    func makeRound() {
        layer.masksToBounds = true
        layer.cornerRadius = bounds.width / 2
    }
    
}
