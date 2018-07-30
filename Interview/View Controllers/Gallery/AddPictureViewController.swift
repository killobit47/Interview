//
//  AddPictureViewController.swift
//  Interview
//
//  Created by Developer on 7/30/18.
//  Copyright © 2018 Roman Ganzha. All rights reserved.
//

import UIKit

class AddPictureViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var hashtagTextField: UITextField!

    var image: UIImage? {
        didSet {
            if let image = image {
                imageView.image = image
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.shared.startUpdatingLocation()
    }

    @IBAction func didTapImageView(_ sender: Any) {
        LocalGalleryManager.shared.locadImage { [weak self] (image, erro) in
            if let image = image {
                self?.image = image.cropToFil()
            }
        }
    }
    
    @IBAction func didTapDoneButton(_ sender: Any) {
        var params: [String: Any] = [:]
        if let description = descriptionTextField.text, let hashtag = hashtagTextField.text {
            params = ["description": description, "hashtag": hashtag]
        }
        if let image = image, let imageDate = UIImageJPEGRepresentation(image, 0.5) {
            params["image"] = imageDate
        } else {
            showAlert(withTitle: "Error", andMessage: "Please, upload the picture.")
            return
        }
        LocationManager.shared.getLocation { (location) in
            params["latitude"] = location.coordinate.latitude
            params["longitude"] = location.coordinate.longitude
            
            ApiManager.request(.image, params, { [weak self] (responseObject, success, error) in
                self?.navigationController?.popViewController(animated: true)
            })
        }
    }
}
