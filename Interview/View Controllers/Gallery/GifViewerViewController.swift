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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    public var gifLink: URL?
    public var imageLink: URL?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        gifImageView.startAnimatingGIF()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let url = gifLink {

            activityIndicator.startAnimating()
            gifImageView.prepareForAnimation(withGIFURL: url, loopCount: 0) { [weak self] in
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.activityIndicator.stopAnimating()
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = imageLink {
            Nuke.loadImage(with: url, options: ImageLoadingOptions(placeholder: UIImage(named: "placeholder"), transition: .fadeIn(duration: 0.33)), into: gifImageView)
        }
    }
    
    @IBAction func didTapHideButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
