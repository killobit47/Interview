//
//  SplashViewController.swift
//  Interview
//
//  Created by Developer on 7/30/18.
//  Copyright © 2018 Roman Ganzha. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let token = ApiManager.loadToken()
        if let _ = token {
            performSegue(withIdentifier: "splashView.toHomeView", sender: nil)
        } else {
            performSegue(withIdentifier: "splashView.toLoginView", sender: nil)
        }
    }
}
