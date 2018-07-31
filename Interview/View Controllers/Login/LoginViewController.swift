
//
//  LoginViewController.swift
//  Interview
//
//  Created by Developer on 7/30/18.
//  Copyright © 2018 Roman Ganzha. All rights reserved.
//

import UIKit
import JGProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func didTapLoginButton(_ sender: Any) {
    
        if let email = emailTextField.text, let password = passwordTextField.text, email.isEmail, password.isValidPass {
            let hud = JGProgressHUD(style: .dark)
            hud.textLabel.text = "I log in."
            hud.show(in: self.view)
            APIManager.login(email: email, password: password) { [weak self] (user, error) in
                if let error = error {
                    hud.textLabel.text = "Error"
                    hud.detailTextLabel.text = error.localizedDescription
                    hud.dismiss(afterDelay: 4, animated: true)
                } else if let _ = user {
                    hud.dismiss(animated: true)
                    self?.performSegue(withIdentifier: Segue.loginSegue.toGallery.rawValue, sender: nil)
                }
            }
        } else {
            showAlert(withTitle: "Warning", andMessage: "Wrong password or email.")
        }
    }
}
