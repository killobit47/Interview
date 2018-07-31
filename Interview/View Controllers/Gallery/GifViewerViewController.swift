//
//  GifViewerViewController.swift
//  Interview
//
//  Created by Developer on 7/30/18.
//  Copyright © 2018 Roman Ganzha. All rights reserved.
//

import UIKit
import Gifu

class GifViewerViewController: UIViewController {

    @IBOutlet weak var gifImageView: GIFImageView!
    public var gifLink: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = gifLink {
            gifImageView.animate(withGIFURL: url)
        }
    }
    
    @IBAction func didTapHideButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
