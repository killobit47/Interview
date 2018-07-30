//
//  GalleryCollectionViewCell.swift
//  Interview
//
//  Created by Developer on 7/30/18.
//  Copyright © 2018 Roman Ganzha. All rights reserved.
//

import UIKit

let GalleryCollectionViewCellID = "GalleryCollectionViewCell"

class GalleryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var weatherLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    class func cellNIB() -> UINib {
        
        return UINib.init(nibName: GalleryCollectionViewCellID, bundle: nil)
        
    }
    
}
