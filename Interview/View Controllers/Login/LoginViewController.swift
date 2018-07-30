
//
//  LoginViewController.swift
//  Interview
//
//  Created by Developer on 7/30/18.
//  Copyright © 2018 Roman Ganzha. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func didTapLoginButton(_ sender: Any) {
    
        if let email = emailTextField.text, let password = passwordTextField.text, email.isEmail, password.isValidPass {
            
            let param = ["email": email,
                         "password": password]
            
            ApiManager.request(.login, param) { [weak self] (response, success, error) in
                
                if !success, let error = error {
                    self?.showAlert(withTitle: "Error", andMessage: error.localizedDescription)
                } else if let response = response as? [String: Any] {
                    if let errorMessage = response["error"] as? String {
                        self?.showAlert(withTitle: "Error", andMessage: errorMessage)
                    } else if let token = response["token"] as? String {
                        ApiManager.saveToken(token)
                        self?.performSegue(withIdentifier: "login.toGallery", sender: nil)
                    }
                } else {
                    self?.showAlert(withTitle: "Error", andMessage: "Something went wrong.")
                }
                
            }
        } else {
            showAlert(withTitle: "Warning", andMessage: "Wrong password or email.")
        }
    }
    
}
