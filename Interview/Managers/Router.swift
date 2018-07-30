//
//  Router.swift
//  Interview
//
//  Created by Developer on 7/30/18.
//  Copyright © 2018 Roman Ganzha. All rights reserved.
//

import UIKit

protocol Router {}

extension Router {

    typealias completion = () -> Void
    
    var topViewController: UIViewController {
        guard var topController = UIApplication.shared.keyWindow?.rootViewController else {
            fatalError("can not get root ViewController")
        }
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
        return topController
    }

    func show(viewController: UIViewController, animated: Bool, completion: (completion)? = nil) {
        topViewController.present(viewController, animated: animated, completion: completion)
    }
    
    func hide(animated: Bool, completion: (completion)? = nil) {
        topViewController.dismiss(animated: animated, completion: completion)
    }
    
    func openApplicationSettings() {
        if let url = URL.init(string: UIApplicationOpenSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
}
