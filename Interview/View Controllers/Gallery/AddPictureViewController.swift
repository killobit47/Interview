//
//  AddPictureViewController.swift
//  Interview
//
//  Created by Developer on 7/30/18.
//  Copyright © 2018 Roman Ganzha. All rights reserved.
//

import UIKit
import JGProgressHUD

let NeedsRefteshCollectionViewNotification = NSNotification.Name.init("needsRefteshCollectionView")


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
        let hashtag = hashtagTextField.text
        let description = descriptionTextField.text
        
        if let image = image, let imageDate = UIImageJPEGRepresentation(image, 0.5) {
            let hud = JGProgressHUD(style: .dark)
            hud.textLabel.text = "Uploading..."
            hud.show(in: self.view)
            
            LocationManager.shared.getLocation { (location) in
                APIManager.uploadPhoto(image: imageDate, description: description, hashtag: hashtag, latitude: CGFloat(location.coordinate.latitude), longitude: CGFloat(location.coordinate.longitude), completion: { [weak self] (image, error) in
                    if let error = error {
                        hud.textLabel.text = "Error"
                        hud.detailTextLabel.text = error.localizedDescription
                        hud.dismiss(afterDelay: 4, animated: true)
                    } else {
                        hud.dismiss(animated: true)
                        NotificationCenter.default.post(name: NeedsRefteshCollectionViewNotification, object: nil)
                        self?.navigationController?.popViewController(animated: true)
                    }
                })
            }
        } else {
            showAlert(withTitle: "Error", andMessage: "Please, upload the picture.")
        }
    }

}
