//
//  SignViewController.swift
//  Interview
//
//  Created by Developer on 7/30/18.
//  Copyright © 2018 Roman Ganzha. All rights reserved.
//

import UIKit
import JGProgressHUD


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
        let username = userNameTextField.text
        if let email = emailTextField.text, let password = passwordTextField.text, email.isEmail, password.isValidPass, let avatar = avatar, let imageDate = UIImageJPEGRepresentation(avatar, 0.5) {

            let hud = JGProgressHUD(style: .dark)
            hud.textLabel.text = "I sign up."
            if let window = self.view {
                hud.show(in: window)
            } else {
                hud.show(in: self.view)
            }
            APIManager.signUP(username: username, email: email, password: password, avatar: imageDate) { [weak self] (user, error) in
                if let error = error {
                    hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    hud.textLabel.text = "Error"
                    if let apierror = error as? APIError {
                        hud.detailTextLabel.text = apierror.localizedDescription
                    } else {
                        hud.detailTextLabel.text = error.localizedDescription
                    }
                    hud.dismiss(afterDelay: 2.5, animated: true)
                } else if let _ = user {
                    hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                    hud.dismiss(animated: true)
                    self?.performSegue(withIdentifier: Segue.siginSegue.toGallery.rawValue , sender: nil)
                }
            }
        } else {
            showAlert(withTitle: "Error", andMessage: "Please complete all fields and avatar.")
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
