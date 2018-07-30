//
//  SignViewController.swift
//  Interview
//
//  Created by Developer on 7/30/18.
//  Copyright © 2018 Roman Ganzha. All rights reserved.
//

import UIKit

class SignViewController: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    
    var avatar: UIImage? {
        didSet {
            avatarImageView.image = avatar
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func didTapSignUpButton(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text, email.isEmail, password.isValidPass, let username = userNameTextField.text, username.isValidUsername {
            var params: [String: Any] = ["username": username, "email": email, "password": password]
            if let avatar = avatar, let imageDate = UIImageJPEGRepresentation(avatar, 0.5) {
                params["avatar"] = imageDate
            } else {
                showAlert(withTitle: "Error", andMessage: "Please, upload the profile avatar picture.")
                return
            }
            ApiManager.request(.create, params) { [weak self] (response, success, error) in
                
                if !success, let error = error {
                    self?.showAlert(withTitle: "Error", andMessage: error.localizedDescription)
                } else if let response = response as? [String: Any] {
                    if let errorMessage = response["error"] as? String {
                        self?.showAlert(withTitle: "Error", andMessage: errorMessage)
                    } else if let token = response["token"] as? String {
                        ApiManager.saveToken(token)
                        self?.performSegue(withIdentifier: "sigin.toGallery", sender: nil)
                    }
                } else {
                    self?.showAlert(withTitle: "Error", andMessage: "Something went wrong.")
                }
                
            }
        } else {
            showAlert(withTitle: "Error", andMessage: "Please complete all fields.")
        }
    }
    
    @IBAction func didTapAvatarImageView(_ sender: UITapGestureRecognizer) {
        LocalGalleryManager.shared.locadImage { [weak self] (image, error) in
            if let image = image {
                self?.avatar = image.cropToFil()
            }
        }
    }
}
