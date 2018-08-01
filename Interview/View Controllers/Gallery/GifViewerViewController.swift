//
//  GifViewerViewController.swift
//  Interview
//
//  Created by Developer on 7/30/18.
//  Copyright © 2018 Roman Ganzha. All rights reserved.
//

import UIKit
import Gifu
import Nuke

class GifViewerViewController: UIViewController {

    @IBOutlet weak var gifImageView: GIFImageView!
    public var gifLink: URL?
    public var imageLink: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = gifLink {
            gifImageView.animate(withGIFURL: url)
        }
        if let url = imageLink {
            Nuke.loadImage(with: url, options: ImageLoadingOptions(placeholder: UIImage(named: "placeholder"), transition: .fadeIn(duration: 0.33)), into: gifImageView)
        }
    }
    
    @IBAction func didTapHideButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
